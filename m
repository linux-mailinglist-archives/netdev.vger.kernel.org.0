Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F03442626B
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 04:21:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233656AbhJHCX0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 22:23:26 -0400
Received: from mx3.wp.pl ([212.77.101.9]:22789 "EHLO mx3.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234089AbhJHCXZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 22:23:25 -0400
Received: (wp-smtpd smtp.wp.pl 29449 invoked from network); 8 Oct 2021 04:14:48 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1633659288; bh=4+iA2jWt06Zj7Wf7mNNn1ZAYUuFTYUHAxtblldAFv6U=;
          h=From:To:Cc:Subject;
          b=EEuFNsE2kS9t5ssacWgxkwcwiivkoloSjdhsPjt1dK96noh1LYbU75w1SFhfAAX1h
           IlQnzMt3pKTmtpEz/Oi0AFtnxNmqLkdY5TtmT7To+zRlei3NYPn9725uCeoRxxgErF
           Z6IQUKhAq5+7XggJE6Uhlm7w58GE37JYhxQhr5a4=
Received: from unknown (HELO kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com) (kubakici@wp.pl@[163.114.132.5])
          (envelope-sender <kubakici@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <colin.king@canonical.com>; 8 Oct 2021 04:14:48 +0200
Date:   Thu, 7 Oct 2021 19:14:42 -0700
From:   Jakub Kicinski <kubakici@wp.pl>
To:     Colin King <colin.king@canonical.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mt7601u: Remove redundant initialization of variable
 ret
Message-ID: <20211007191442.2da691df@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211007234153.31222-1-colin.king@canonical.com>
References: <20211007234153.31222-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-WP-MailID: 97d23a12387b9de539baf411b446f3b8
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000003 [YVDm]                               
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  8 Oct 2021 00:41:53 +0100 Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The variable ret is being initialized with a value that is never read,
> it is assigned later on with a different value. The initialization is
> redundant and can be removed.
> 
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Acked-by: Jakub Kicinski <kubakici@wp.pl>
