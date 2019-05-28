Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 514962CED8
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 20:44:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728090AbfE1Sor (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 14:44:47 -0400
Received: from mail-pl1-f172.google.com ([209.85.214.172]:33231 "EHLO
        mail-pl1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726917AbfE1Son (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 14:44:43 -0400
Received: by mail-pl1-f172.google.com with SMTP id g21so8720585plq.0
        for <netdev@vger.kernel.org>; Tue, 28 May 2019 11:44:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=appneta.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=DFjPQf88/WEdwbAZuIhMdfy4wl7j7rHm9z/e0KQ/ick=;
        b=M7uebHrMZD2HFYCwXvvZYPGRo6TZmmPcaT61c1V+suPKNemNiMOv3XkQNEEEpt6Chc
         eJmV8ECUTE/nN2/z+7ayAwjyab9hS2gqTwmwbAAsHRBRLncIXHaj69WqAnInVSjftf9k
         Fdw+bSlBm5idQeiAkvrhLLc3PHUusTXgewlqE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=DFjPQf88/WEdwbAZuIhMdfy4wl7j7rHm9z/e0KQ/ick=;
        b=HTgVK8uEDp4pB1xOGYCX/pujTLaiE3+5obcovEqNhYq0Rp7eEAZparGuYN3HwMuWuZ
         cg6gWDAhCeK+ySHtpJkxL2SCaLegGnZXDRuyMTFwPYY15jOx9Jl9BDdlK2+B1DKNb644
         85bJmvendpGuO5JZoUpeviJuONU9U3TC+W9OsiwQNvyZft0yaIoEOz3xol5m1Y1tUYaC
         09x/cHVfQgqijxlPvBDiZgwGQfg2ay+SndVV24dPpVtDOlR9qtqXkM+FtuuT8Hz/Prov
         8libH9AZ6/OMTILmAiLJX3fG/hQTqKIi15TgSyk2zeUTznujQGrd5oWOrZVIXkR/zZdM
         IP+w==
X-Gm-Message-State: APjAAAUIcVkL38Ox5uikHgho2f2bYApPRcaGViADTfcik3oVRRX8m+S1
        rMULjX5uU1zC3fhDaoh9lnvAehUgQPXuvw==
X-Google-Smtp-Source: APXvYqwK8CwFA8GFX8OZgMGUz/uu9etWgEoQtN2jsuFurBEAh1VqlXKuwiXif0AXzRc+yEI1bFtYaw==
X-Received: by 2002:a17:902:8209:: with SMTP id x9mr9499883pln.327.1559069082854;
        Tue, 28 May 2019 11:44:42 -0700 (PDT)
Received: from linux-net-fred.jaalam.net ([2001:4958:15a0:24:5054:ff:fecb:7a95])
        by smtp.googlemail.com with ESMTPSA id j72sm3534085pje.12.2019.05.28.11.44.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 May 2019 11:44:42 -0700 (PDT)
From:   Fred Klassen <fklassen@appneta.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Willem de Bruijn <willemb@google.com>
Cc:     Fred Klassen <fklassen@appneta.com>
Subject: [PATCH net-next v3 0/1] Allow TX timestamp with UDP GSO
Date:   Tue, 28 May 2019 11:44:14 -0700
Message-Id: <20190528184415.16020-1-fklassen@appneta.com>
X-Mailer: git-send-email 2.11.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes an issue where TX Timestamps are not arriving on the error queue
when UDP_SEGMENT CMSG type is combined with CMSG type SO_TIMESTAMPING.

Fred Klassen (1):
  net/udp_gso: Allow TX timestamp with UDP GSO

 net/ipv4/udp_offload.c | 5 +++++
 1 file changed, 5 insertions(+)

-- 
2.11.0

