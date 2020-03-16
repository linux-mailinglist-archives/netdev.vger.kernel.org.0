Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E841F1866C4
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 09:43:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730179AbgCPIm7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 04:42:59 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40966 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730069AbgCPIm6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 04:42:58 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 58ACE1424181E;
        Mon, 16 Mar 2020 01:42:58 -0700 (PDT)
Date:   Mon, 16 Mar 2020 01:42:57 -0700 (PDT)
Message-Id: <20200316.014257.1164923206336857637.davem@davemloft.net>
To:     mayflowerera@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] macsec: Netlink support of XPN cipher suites
 (IEEE 802.1AEbw)
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200309194702.117050-2-mayflowerera@gmail.com>
References: <20200309194702.117050-1-mayflowerera@gmail.com>
        <20200309194702.117050-2-mayflowerera@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 16 Mar 2020 01:42:58 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Era Mayflower <mayflowerera@gmail.com>
Date: Mon,  9 Mar 2020 19:47:02 +0000

> Netlink support of extended packet number cipher suites,
> allows adding and updating XPN macsec interfaces.
> 
> Added support in:
>     * Creating interfaces with GCM-AES-XPN-128 and GCM-AES-XPN-256 suites.
>     * Setting and getting 64bit packet numbers with of SAs.
>     * Setting (only on SA creation) and getting ssci of SAs.
>     * Setting salt when installing a SAK.
> 
> Added 2 cipher suite identifiers according to 802.1AE-2018 table 14-1:
>     * MACSEC_CIPHER_ID_GCM_AES_XPN_128
>     * MACSEC_CIPHER_ID_GCM_AES_XPN_256
> 
> In addition, added 2 new netlink attribute types:
>     * MACSEC_SA_ATTR_SSCI
>     * MACSEC_SA_ATTR_SALT
> 
> Depends on: macsec: Support XPN frame handling - IEEE 802.1AEbw.
> 
> Signed-off-by: Era Mayflower <mayflowerera@gmail.com>

Applied.
