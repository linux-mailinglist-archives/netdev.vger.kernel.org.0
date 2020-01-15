Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8814713C7FB
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 16:36:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729047AbgAOPgc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 10:36:32 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:37286 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726566AbgAOPgc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 10:36:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579102591;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=OLGq1v+duVKovXUpTa7IDyar7ute+DPtXcyN071gcT4=;
        b=ZDDF9xAtm1FeZIK1NsInwfeHbeyZ5t49h46zATiNs2I4OudAui3luOyDA1aDV6FngAyKA3
        sHvEHxV1Nd2CRf5UGVd7vOh7lu/C/HIj3STMxOsuClYQF//u7kUnUKENHaeLVIu4YeHHJv
        OpYR9RYT7qx/WybDQKxZFFPyfPrfVNI=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-116-enl_nxl4Pca4Yl3Cu3CBrA-1; Wed, 15 Jan 2020 10:36:29 -0500
X-MC-Unique: enl_nxl4Pca4Yl3Cu3CBrA-1
Received: by mail-wr1-f72.google.com with SMTP id v17so8089071wrm.17
        for <netdev@vger.kernel.org>; Wed, 15 Jan 2020 07:36:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=OLGq1v+duVKovXUpTa7IDyar7ute+DPtXcyN071gcT4=;
        b=RmZmRa2r/X+cHL3jd8pZxArRH8IETiqFvxNyfNEo/j7LxU3E6tR66k8jhH2QjQpge+
         mbP/CzfJlglTGjtiUFu6L+MRsN3Sqw27iwtv9PrkOA4WqmVq9CGQoiJh28aqVeLnPwCD
         HgcKcH6/+43AyIEAPgrdxkdwVfo20vqTTp1HSF/hYWAxwB6kab6yhjlgmg09Ruwdbiyw
         N/owUt50dLHHK3xBFekNUDnYK1xIJ3q/7iz/3uyoR/sQEToQg6hYhQPLc5WZcoEpbGYx
         VF2necd13xzqnkLqSpOFvrvmfNeFJTBbqwjt4Qo6XwlKsQB33cBqqBL3T7HC1el7mal2
         9Pyw==
X-Gm-Message-State: APjAAAXVJR0QmGk0DRBhSe3s2Y8gh5phpvz70vJKYaJJM0nIbtVQ3Z5K
        Wtc2aahMYTdFq47TsHS497UgdN9Zp4gZa1wi7sARst3EYP5ThPViXlzub4Eas52W/vCDl4+NZqD
        dJA7RAsa87kIxajEE
X-Received: by 2002:adf:e78a:: with SMTP id n10mr32963156wrm.62.1579102588481;
        Wed, 15 Jan 2020 07:36:28 -0800 (PST)
X-Google-Smtp-Source: APXvYqwLikC/vuagvfhrgwNxXTwc2mJLUBnbCdJIqenu0bOofQKxLl7ZniaLBNflCocmTIza1ko7aQ==
X-Received: by 2002:adf:e78a:: with SMTP id n10mr32963134wrm.62.1579102588281;
        Wed, 15 Jan 2020 07:36:28 -0800 (PST)
Received: from linux.home (2a01cb058a4e7100d3814d1912515f67.ipv6.abo.wanadoo.fr. [2a01:cb05:8a4e:7100:d381:4d19:1251:5f67])
        by smtp.gmail.com with ESMTPSA id f12sm216615wmf.28.2020.01.15.07.36.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jan 2020 07:36:27 -0800 (PST)
Date:   Wed, 15 Jan 2020 16:36:26 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH net-next v2 0/2] netns: simple cleanups
Message-ID: <cover.1579102319.git.gnault@redhat.com>
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

v2: also update IFLA_NET_NS_* in rtnetlink.c.

Guillaume Nault (2):
  netns: Parse *_PID and *_FD netlink attributes as signed integers
  netns: constify exported functions

 include/net/net_namespace.h | 10 +++++-----
 net/core/net_namespace.c    | 18 +++++++++---------
 net/core/rtnetlink.c        |  8 ++++----
 3 files changed, 18 insertions(+), 18 deletions(-)

-- 
2.21.1

