Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16693176E66
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 06:08:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725946AbgCCFIp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 00:08:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:40382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725807AbgCCFIo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Mar 2020 00:08:44 -0500
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C522520717;
        Tue,  3 Mar 2020 05:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583212124;
        bh=6WNg9jfF5uoWfEmzf0p2XimGRnfTXrTHIRMT6sm+4jY=;
        h=From:To:Cc:Subject:Date:From;
        b=asdvWK8+k0u8BCWoJ4WVkxnJS0St03n9FmO0guSuBKrBYVs6AaJJj8xvAEja00a+L
         9F1h7Y+4Is8ZdYAvM3QK5IWa2wbuk7SxR+FCZGvYmPOyZ/JY9KDnH5aOVrsB17jeTa
         nee5W5YBobeuHC5C9wsNv0c0hBAn0Y0RVzR+LjHs=
From:   Jakub Kicinski <kuba@kernel.org>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org, fw@strlen.de,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH netfilter 0/3] netfilter: add missing attribute validation
Date:   Mon,  2 Mar 2020 21:08:30 -0800
Message-Id: <20200303050833.4089193-1-kuba@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

Netfilter and nf_tables is missing a handful of netlink policy entries.

Compilation tested only.

Jakub Kicinski (3):
  netfilter: add missing attribute validation for cthelper
  netfilter: add missing attribute validation for payload csum flags
  netfilter: nf_tables: add missing attribute validation for tunnels

 net/netfilter/nfnetlink_cthelper.c | 2 ++
 net/netfilter/nft_payload.c        | 1 +
 net/netfilter/nft_tunnel.c         | 2 ++
 3 files changed, 5 insertions(+)

-- 
2.24.1

