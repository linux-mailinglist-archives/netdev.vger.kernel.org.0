Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC84A6EAC4C
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 16:09:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232144AbjDUOJO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 10:09:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232495AbjDUOJN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 10:09:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FD4AC173;
        Fri, 21 Apr 2023 07:09:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DC72C619A3;
        Fri, 21 Apr 2023 14:09:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A126EC4339B;
        Fri, 21 Apr 2023 14:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682086147;
        bh=EcPNXFz/2vVBZwu2kGf48w1/9yroyC/oDcQGDWlaWD4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=l762Ds4IhBIA3pDqYDAK5zYE7oMetEGBSsLPgxtyug0MaLQ2XHqkJby7JBsBra4LZ
         GYp+AydBkNWpGVnMRho3Ijd3lM2a8P7AB2vh3UT1VWbpPAnrqxygqUC6iD52UyO5W0
         tO/vkdhU0wPUBFTQkSJfJ7DgE8NlQNo0Sby0xC5yHviWeYDQ+bS3ryvwnCINNoCp8Y
         AeL+FbeLE+Fdh/TXxkxgNDtqJdRDJWiiCiszI0ar6prl5FDGBawMBBzo2lEWJ0sZCh
         ckt0N3KVhUhrmhM04/DvTcJwErRGwgGwU8HBgS6lm49RgrKMfu+qSGfuoC4wxOhmez
         yOoB/ouIHlKjg==
Date:   Fri, 21 Apr 2023 07:09:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Andrzej Hajda <andrzej.hajda@intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>, linux-kernel@vger.kernel.org,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        netdev@vger.kernel.org, Dmitry Vyukov <dvyukov@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andi Shyti <andi.shyti@linux.intel.com>
Subject: Re: [PATCH v7 0/7] drm/i915: use ref_tracker library for tracking
 wakerefs
Message-ID: <20230421070905.3ed2bb78@kernel.org>
In-Reply-To: <20230224-track_gt-v7-0-11f08358c1ec@intel.com>
References: <20230224-track_gt-v7-0-11f08358c1ec@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 21 Apr 2023 13:35:04 +0200 Andrzej Hajda wrote:
> Gently ping for network developers, could you look at ref_tracker patches,
> as the ref_tracker library was developed for network.

Putting Eric in the To: field, I know email so hard and confusing...
