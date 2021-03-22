Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58FD934380F
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 05:59:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbhCVE6z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 00:58:55 -0400
Received: from mail2.directv.syn-alias.com ([69.168.106.50]:22542 "EHLO
        mail.directv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbhCVE6l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 00:58:41 -0400
DKIM-Signature: v=1; a=rsa-sha1; d=wildblue.net; s=20170921; c=relaxed/simple;
        q=dns/txt; i=@wildblue.net; t=1616389121;
        h=From:Subject:Date:To:MIME-Version:Content-Type;
        bh=+/gMcM2JLBRroFSmmYDV09lAd+8=;
        b=aEBR2siOJuqv/rm5z5J5AbF615NIrG+m/+vcHP7Slg+wpQ5asRYaJrOKaxPwxqSE
        DtEqLWPMujebOyoENGD/DlPj1j6ZC3+727OcX/xjgBsZhSxBFPw0Eoj4TWoUxbNS
        /EDs1LxVZ3gJr80+rzyUElVWpPgnye/q4DgzGovItxI2TQze+L4MI/we/KrIqgrE
        zLWwZXBT2BQiCPmH2fYepKqTRqkhb4VA0WEUbRStH3G3NMtFnfe73g+fQNML9xLi
        ikgILJxNII7KPJx8/dAgySQt94BvMuNDnYWscM739G5nkIvgyzAgLNkbcG7XoKgK
        NK7uVXhzLV/SOu9NvrME0w==;
X-Authed-Username: am9iZWFyQHdpbGRibHVlLm5ldA==
Received: from [10.80.118.23] ([10.80.118.23:57708] helo=md05.jasper.bos.sync.lan)
        by mail2.directv.syn-alias.com (envelope-from <jobear@wildblue.net>)
        (ecelerity 3.6.25.56547 r(Core:3.6.25.0)) with ESMTP
        id 05/76-28646-00428506; Mon, 22 Mar 2021 00:58:40 -0400
Date:   Mon, 22 Mar 2021 00:58:40 -0400 (EDT)
From:   Rowell Hambrick <jobear@wildblue.net>
Reply-To: rowellhabrick@gmail.com
To:     mlz1988@126.com
Message-ID: <898819262.41147444.1616389120367.JavaMail.zimbra@wildblue.net>
Subject: 
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [91.132.136.92]
X-Mailer: Zimbra 8.7.6_GA_1776 (zclient/8.7.6_GA_1776)
Thread-Index: TdjUVqTVwdGShwLFEmMWnu5gWHJhWQ==
Thread-Topic: 
X-Vade-Verditct: clean
X-Vade-Analysis: gggruggvucftvghtrhhoucdtuddrgeduledrudegfedgjeekucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuufgjpfetvefqtfdpggfktefutefvpdfqfgfvnecuuegrihhlohhuthemuceftddunecugfhmphhthicushhusghjvggtthculddutddmnecujfgurhepfffhrhfvkffugggtgfhiofhtsehtjegttdertdejnecuhfhrohhmpeftohifvghllhcujfgrmhgsrhhitghkuceojhhosggvrghrseifihhluggslhhuvgdrnhgvtheqnecuggftrfgrthhtvghrnhepuefhueetledtuefhffdvgefhfeehveeufedufffhleeljeeiffekvdekfeetheeunecukfhppedutddrkedtrdduudekrddvfedpledurddufedvrddufeeirdelvdenucevlhhushhtvghrufhiiigvpeehnecurfgrrhgrmhepihhnvghtpedutddrkedtrdduudekrddvfeenpdhmrghilhhfrhhomhepjhhosggvrghrseifihhluggslhhuvgdrnhgvthenpdhrtghpthhtohepnhhhugigiiiifiesqhhqrdgtohhmne
X-Vade-Client: VIASAT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Do you get my last mail
