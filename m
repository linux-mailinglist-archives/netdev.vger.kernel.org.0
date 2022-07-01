Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 259765634E5
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 16:11:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231553AbiGAOLn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 10:11:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbiGAOLm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 10:11:42 -0400
Received: from eidolon.nox.tf (eidolon.nox.tf [IPv6:2a07:2ec0:2185::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C13DA34BA7;
        Fri,  1 Jul 2022 07:11:41 -0700 (PDT)
Received: from equinox by eidolon.nox.tf with local (Exim 4.94.2)
        (envelope-from <equinox@diac24.net>)
        id 1o7HMw-00HAFx-ED; Fri, 01 Jul 2022 16:11:38 +0200
Date:   Fri, 1 Jul 2022 16:11:38 +0200
From:   David Lamparter <equinox@diac24.net>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        corbet@lwn.net, linux-doc@vger.kernel.org
Subject: Re: [PATCH net-next] eth: remove neterion/vxge
Message-ID: <Yr8Amo0lQzfia4+3@eidolon.nox.tf>
References: <20220701044234.706229-1-kuba@kernel.org>
 <Yr7NpQz6/esZAiZv@nanopsycho>
 <Yr7z7HU2Z79pMrM0@eidolon.nox.tf>
 <Yr7/UwsV4mqg0I5t@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yr7/UwsV4mqg0I5t@nanopsycho>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 01, 2022 at 04:06:11PM +0200, Jiri Pirko wrote:
> Fri, Jul 01, 2022 at 03:17:32PM CEST, equinox@diac24.net wrote:
> >As a "reference datapoint", I'm a user that was affected by the removal
> >of the Mellanox SwitchX-2 driver about a year ago.  But that was a bit
> 
> You could not be. There was really no functionality implemented in
> switchx2 driver. I doubt you used 32x40G port switch with slow-path
> forwarding through kernel with total max bandwidth of like 1-2G for the
> whole switch :)

Funny you would mention that, that's exactly as far as I got - on some
attempts at least, when I didn't get an initialization failure after a
15 minute reset timer ;D
