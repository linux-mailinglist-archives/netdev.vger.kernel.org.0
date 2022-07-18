Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AF205785A3
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 16:40:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232987AbiGROkp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 10:40:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbiGROko (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 10:40:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F9482409E;
        Mon, 18 Jul 2022 07:40:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BBE1D60DFA;
        Mon, 18 Jul 2022 14:40:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 506A1C341C0;
        Mon, 18 Jul 2022 14:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658155242;
        bh=NeYIO0BqbILJrEgXnGSOv7KPU6f7mitEcw6t9jGVMfE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DdbJj6NkLQnB/9sdUT5i0gi9jxEcUfDCgZY3JNE78yS8gnqNglUr/+m5YpgVe8aei
         S63HRa0Th9e4YKk8BYmp82WS1EAbGUfLtePmPpYeUvyYbRBXDjqhptiIk1kkuPbT7t
         /0JVXcI/rTJwuDM0amNaBWLhegYPyn1IZLlAKpGg=
Date:   Mon, 18 Jul 2022 16:40:38 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     =?utf-8?Q?=C5=81ukasz?= Spintzyk <lukasz.spintzyk@synaptics.com>
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        oliver@neukum.org, kuba@kernel.org, ppd-posix@synaptics.com,
        Bernice.Chen@synaptics.com
Subject: Re: [PATCH v3 1/2] net/cdc_ncm: Enable ZLP for DisplayLink ethernet
 devices
Message-ID: <YtVw5ooWFYRZ8gOk@kroah.com>
References: <YtAJ2KleMpkeFfQq@kroah.com>
 <20220718123618.7410-1-lukasz.spintzyk@synaptics.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220718123618.7410-1-lukasz.spintzyk@synaptics.com>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 18, 2022 at 02:36:17PM +0200, Łukasz Spintzyk wrote:
> From: Dominik Czerwik <dominik.czerwik@synaptics.com>
> 
> This improves performance and stability of
> DL-3xxx/DL-5xxx/DL-6xxx device series.
> 
> Specifically prevents device from temporary network dropouts when
> playing video from the web and network traffic going through is high.
> 
> Signed-off-by: Dominik Czerwik <dominik.czerwik@synaptics.com>
> Signed-off-by: Łukasz Spintzyk <lukasz.spintzyk@synaptics.com>
> ---
> 
> v3: We have decided to remove that copyright as this is not really 
>     necessary.

Thank you for working with your lawyers on this, hopefully this is not
confusing anymore.

greg k-h
