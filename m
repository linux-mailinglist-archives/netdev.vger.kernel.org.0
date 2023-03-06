Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B08B6AC1D0
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 14:50:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbjCFNt6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 08:49:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbjCFNt4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 08:49:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 438C45582;
        Mon,  6 Mar 2023 05:49:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C725360F06;
        Mon,  6 Mar 2023 13:49:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C75AC433EF;
        Mon,  6 Mar 2023 13:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678110594;
        bh=nBD2Xp8SETidcWqV6Sq9OLyZ3TFTr8gYyUqKe18Rt9A=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=U9gN1YDF+h09i16MEiZisnPStanjPEUTbGK+0eqvkzUNHLdKj5hpDJWvQIn8DQ0QA
         Pcye6bJLcfnwitw4a28yjdGoi81Vqwrt5JRst+099SbF4/oelzTG4pxt8oRpYERYv+
         GV/xC206CxBrqzkZQhwpX8t5t5lg0vpcoULQVcnqeQ6xiHd8PACT5HdW6SYgnvNp+o
         yEfWESMgQS0gZRecJd2CeshTNqH3sdmBBUmvyWfOiWODCtXp3IhNj5188MacedjKx/
         zeYdFtUl3gyIOER2Iee4t+yLAkndqM+toRemWVO37l2oHIgObmng3y2xco4bFMglQ7
         MdoQ9jNrNaRYw==
From:   Kalle Valo <kvalo@kernel.org>
To:     Bastian Germann <bage@debian.org>
Cc:     toke@toke.dk, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] wifi: ath9k: Remove Qwest/Actiontec 802AIN ID
References: <20230305210245.9831-1-bage@debian.org>
        <20230306125041.2221-1-bage@debian.org> <87wn3uowov.fsf@kernel.org>
        <f73bd7ce-dd44-cd10-8727-38f8cf6354bd@debian.org>
Date:   Mon, 06 Mar 2023 15:49:47 +0200
In-Reply-To: <f73bd7ce-dd44-cd10-8727-38f8cf6354bd@debian.org> (Bastian
        Germann's message of "Mon, 6 Mar 2023 14:36:02 +0100")
Message-ID: <87sfeioupw.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bastian Germann <bage@debian.org> writes:

> Am 06.03.23 um 14:07 schrieb Kalle Valo:
>> Bastian Germann <bage@debian.org> writes:
>>
>>> The USB device 1668:1200 is Qwest/Actiontec 802AIN which is also
>>> correctly claimed to be supported by carl9170.
>>>
>>> Supposedly, the successor 802AIN2 which has an ath9k compatible chip
>>> whose USB ID (unknown) could be inserted instead.
>>>
>>> Drop the ID from the wrong driver.
>>>
>>> Signed-off-by: Bastian Germann <bage@debian.org>
>>
>> Thanks, I see this patch now.
>>
>> I guess there's a bug report somewhere, do you have a link?
>
> No, I happened to find this by chance while packaging the ath9k and
> carl9170 firmware for Debian,
> which have the ID represented in an XML format:
> https://salsa.debian.org/debian/open-ath9k-htc-firmware/-/blob/master/debian/firmware-ath9k-htc.metainfo.xml

Do you mind if we add this (without the link) to the commit log? It's
good to always document the background of the patch.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
