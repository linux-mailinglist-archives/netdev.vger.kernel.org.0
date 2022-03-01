Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 976084C898D
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 11:41:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233511AbiCAKmX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 05:42:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbiCAKmX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 05:42:23 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE42390263;
        Tue,  1 Mar 2022 02:41:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 307B1CE1AA6;
        Tue,  1 Mar 2022 10:41:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4AB4C340EE;
        Tue,  1 Mar 2022 10:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646131299;
        bh=Kzzp44SET/aCdgugpWmrDv1RkqN5ADkJiDTXbCPI9b0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wB5aSQ2Lr2lElnMqlKyyMBxw9Eyoj9ds034vzZp1l5D3R3lq5tSZCe8CGzEkzKGHG
         97mKL258ojVOcHxJPOz92FbjsYQqIm3rMGelgeouRT67iiJon/JRUHmGdROblpRLzo
         Xgfv4gDUhSQft0qFfhx8XG0DZohLAW0P1o1MIGrs=
Date:   Tue, 1 Mar 2022 11:41:34 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Xiaomeng Tong <xiam0nd.tong@gmail.com>
Cc:     torvalds@linux-foundation.org, arnd@arndb.de,
        jakobkoschel@gmail.com, linux-kernel@vger.kernel.org,
        keescook@chromium.org, jannh@google.com,
        linux-kbuild@vger.kernel.org, linux-mm@kvack.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 3/6] kernel: remove iterator use outside the loop
Message-ID: <Yh34XhiUg6T/14kF@kroah.com>
References: <20220301075839.4156-1-xiam0nd.tong@gmail.com>
 <20220301075839.4156-4-xiam0nd.tong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220301075839.4156-4-xiam0nd.tong@gmail.com>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 01, 2022 at 03:58:36PM +0800, Xiaomeng Tong wrote:
> Demonstrations for:
>  - list_for_each_entry_inside
>  - list_for_each_entry_continue_inside
>  - list_for_each_entry_safe_continue_inside

This changelog does not make much sense at all.  Why are you making
these changes and how are we to review them?  Same for the others in
this series.

confused,

greg k-h
