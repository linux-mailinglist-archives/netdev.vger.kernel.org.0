Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F66F4C9B2C
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 03:24:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234357AbiCBCZX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 21:25:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233076AbiCBCZW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 21:25:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2421DA88A3
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 18:24:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C367FB81EE4
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 02:24:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 361CCC340F2;
        Wed,  2 Mar 2022 02:24:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646187877;
        bh=+7OdUAKzElXJIddyFW7wzltw5qosaP6A0xl0UUpDDG8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=S5ZOenHrfHIrwXJQtJX4Hcto2PUN4Tu9E/2jM0FO82jbv++9s78DRKP7/Tllhmboo
         W5JEmjTNceYhf+tBQA6U6eVPPu3M6kLeq1g26M/JvL5h6HgT7xClfYIS89pahXTkjb
         nMg92i8UGTuU//2FU8O8scze/rMuDFci5jFu/HLoBAZe0JbwjtwfmLFg90ghaO0cQq
         FLHMvz8RrXoLk54+sJ7VlYLEJ34OFCIrB0zIQIg/svCkuu69tTEXIIBgQrZljwkD+i
         4LM40h5299veMdIzwhGjU7G8EOBhqei2xbEUw4mSmfqHMJioSvZbb7O/W2xgfcCN3L
         EZdtF3RkqdEqw==
Date:   Tue, 1 Mar 2022 18:24:36 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Manish Chopra <manishc@marvell.com>
Cc:     <netdev@vger.kernel.org>, <aelior@marvell.com>, <palok@marvell.com>
Subject: Re: [PATCH net-next 2/2] qed: validate and restrict untrusted VFs
 vlan promisc mode
Message-ID: <20220301182436.65d0eeed@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220228200708.4312-2-manishc@marvell.com>
References: <20220228200708.4312-1-manishc@marvell.com>
        <20220228200708.4312-2-manishc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 28 Feb 2022 12:07:08 -0800 Manish Chopra wrote:
> +	tlv_mask = BIT(QED_IOV_VP_UPDATE_ACCEPT_PARAM) | BIT(QED_IOV_VP_UPDATE_ACCEPT_ANY_VLAN);

Please break this long line

> +
>  

and remove the double empty line.


Are you sure you don't want this to go in as a fix and into the LTS
releases?
