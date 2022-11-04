Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 554B661A01E
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 19:36:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232216AbiKDSgF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 14:36:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230045AbiKDSgD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 14:36:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5FA540931;
        Fri,  4 Nov 2022 11:35:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6DE33622FB;
        Fri,  4 Nov 2022 18:35:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5118CC433D6;
        Fri,  4 Nov 2022 18:35:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667586957;
        bh=VPj9cmh6AQFP0VK/8I1kT7FJ9030U5M07JRujBjXtss=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sQbWWomwLEvYnjJKkidFiGQ28C8Q1HidFmegtNdDhJZSVz2riozKuI+h6yavtGznE
         Z2KDFcZtgfh5LAyksLsQXJvjXfD8rE8hnJ83uOQ8o3XoopYB2PXbFOr30342+1nYmB
         GBOH4VgLtWNPoRne/PUemG5sV4elSyLF3EhnqJNWSeB3EhmE2AOrmOeRusYAIUG3O2
         +bqWH0D4HAzPtxEt6oILW6LnlMACedeW2ygnXb+61wxxuP/+2FCQIgE6dDBSNJRF8y
         nFMJJCymy1JNsHvgMVHBipZ0sJDx2SzwLpGTBv+5FE+CKwG0iQDPlHOI/gsNmnaTJ2
         PYBzFjFj+wedA==
Date:   Fri, 4 Nov 2022 11:35:56 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ahelenia =?UTF-8?B?WmllbWlhxYRza2E=?= 
        <nabijaczleweli@nabijaczleweli.xyz>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, coda@cs.cmu.edu,
        codalist@coda.cs.cmu.edu, linux-arm-kernel@lists.infradead.org,
        linux-doc-tw-discuss@lists.sourceforge.net,
        linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-hams@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-scsi@vger.kernel.org,
        netdev@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH v2 00/15] magic-number.rst funeral rites
Message-ID: <20221104113556.488c4e17@kernel.org>
In-Reply-To: <cover.1667330271.git.nabijaczleweli@nabijaczleweli.xyz>
References: <cover.1667330271.git.nabijaczleweli@nabijaczleweli.xyz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2 Nov 2022 00:04:54 +0100 Ahelenia Ziemia=C5=84ska wrote:
> This is a follow-up for the 18+1-patch series (
> https://lore.kernel.org/linux-kernel/8389a7b85b5c660c6891b1740b5dacc53491=
a41b.1663280877.git.nabijaczleweli@nabijaczleweli.xyz/
> https://lore.kernel.org/linux-kernel/20220927003727.slf4ofb7dgum6apt@tart=
a.nabijaczleweli.xyz/
> ) I sent in September, and the same reasoning applies:

No idea how you want this to get merged, but FWIW you can add my

Acked-by: Jakub Kicinski <kuba@kernel.org>

to patches 1, 2, 11 and 12.
