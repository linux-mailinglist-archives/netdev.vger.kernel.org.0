Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EEB313B549
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 23:25:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728754AbgANWZ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 17:25:28 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:32722 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727102AbgANWZ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 17:25:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579040727;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=9WeghuA7gxlwQppVAd8V+uNDHsMCiDYgrmsUEfQYjyY=;
        b=Y+7U12Y2be9UhwGzRLWFyNeDl0xPt3EvuheBLCqddd8FWRN4q2rydG4fiWFMxofjaLx29G
        6SzcbIYB7kN6C8ldJ+f3/k9yiqhSCUXqtURErf7mbPiKUgyNViRHuUcmfrkiNrvaw1hbj7
        amhEdWXsGjtDMWSjUrCHWG7O9qlBy/A=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-375-abQdcAQiMaGpABvp-qFcNg-1; Tue, 14 Jan 2020 17:25:23 -0500
X-MC-Unique: abQdcAQiMaGpABvp-qFcNg-1
Received: by mail-wr1-f70.google.com with SMTP id r2so7106757wrp.7
        for <netdev@vger.kernel.org>; Tue, 14 Jan 2020 14:25:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=9WeghuA7gxlwQppVAd8V+uNDHsMCiDYgrmsUEfQYjyY=;
        b=oViy+rN14Z6FTGonN/Hy9SFO4QmW7aff+YGZWzmgqNEOdZAc+rF1CsE6VrdWH/7AcB
         2txhfXzkyohLzHMrtxdIiwrYQXDZN5Pr01zQPuhtb6tERNLVmj5NtR0trpXue3QTh7dQ
         obmuS40v4yi+agX2wH1/gTfgsEaYrAFSr28P2MIq0OMwvTpTJlkDDn3TshvKaDSTeynN
         F7XRCuhecmaRPbMQ8pjxnamyraBS1MwhPvsZYqCIVpTiOf78yXJo9cSECTFAqKCRu5GH
         z9TkDZdA+cgWuhmqRvxcATZ9UaFOhF/oNtS5P5PgI9haURFAuQD2bcwNA/HNZcKzWMNh
         hH9Q==
X-Gm-Message-State: APjAAAU4NaOHdCGKerJgjpD8tMIkY7MYJz1+mW/csJTyUIBo/AGss4vK
        kv+aSH/6GkB9anCPlH4DmOU2jgwHDtxymslia0OwZYIjCS3jlRNzEvX+HUYC5lv6Dgo4lLeP8tk
        +sqI+AlsiqWauU0nf
X-Received: by 2002:adf:fe8c:: with SMTP id l12mr25950092wrr.215.1579040722815;
        Tue, 14 Jan 2020 14:25:22 -0800 (PST)
X-Google-Smtp-Source: APXvYqzXFhbkWp4e1lTCHuBTsq/ZCSeNZxhQRw5uAC+CToA7D+1ZzyhSX4cFz8tJmCnkp56k/Ohq9Q==
X-Received: by 2002:adf:fe8c:: with SMTP id l12mr25950073wrr.215.1579040722548;
        Tue, 14 Jan 2020 14:25:22 -0800 (PST)
Received: from linux.home (2a01cb058a4e7100d3814d1912515f67.ipv6.abo.wanadoo.fr. [2a01:cb05:8a4e:7100:d381:4d19:1251:5f67])
        by smtp.gmail.com with ESMTPSA id b15sm20229978wmj.13.2020.01.14.14.25.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jan 2020 14:25:22 -0800 (PST)
Date:   Tue, 14 Jan 2020 23:25:20 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH net-next 0/2] netns: simple cleanups
Message-ID: <cover.1579040200.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A few things to cleanup, found while working on net_namespace.c:
  * align netlink attribute parsing policy with their real usage,
  * some constification.

Guillaume Nault (2):
  netns: Parse NETNSA_FD and NETNSA_PID as signed integers
  netns: constify exported functions

 include/net/net_namespace.h | 10 +++++-----
 net/core/net_namespace.c    | 18 +++++++++---------
 2 files changed, 14 insertions(+), 14 deletions(-)

-- 
2.21.1

