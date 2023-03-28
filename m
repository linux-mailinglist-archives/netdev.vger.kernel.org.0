Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FE176CB438
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 04:38:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230412AbjC1Civ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 22:38:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232134AbjC1Cit (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 22:38:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1A4A268A;
        Mon, 27 Mar 2023 19:38:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4C775B81A21;
        Tue, 28 Mar 2023 02:38:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60DE5C433D2;
        Tue, 28 Mar 2023 02:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679971124;
        bh=haiNNCFIgU/36Qf7gUJ5gePna0haIPwwmpm8cjK1iRE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PURgN0HTfUbNhVGjrkrXlKWUkCXXSNbzTIPc1qXjQBIygoJUMhFVKTmxXVAWpulma
         2V5/DZaS2+wGXFkTdR/9QBpu3s12kiR+CFriUXHFeQf99Q1KYswDJ+fDd0MzeF6GlU
         ELy4yKp9E5W9RA4y88QrfOuO2IDX5uxLDpcyitDJ/WMy6z9xoyEYeb7nX/mis3HKfH
         HudoPkGL8Uo0E0UJbPYyeeR+xRqVRIhRBwU4EZAK/JG/TfWxPL0Hr4X+8ytKz8QLiY
         /8dsbx7sTbbd+dB33QiLle/+ohER2TAUxHEkJbnHZeHa5fc1tdn4mX9d22d+vpOndQ
         BdGbFwlNPqHpA==
Date:   Mon, 27 Mar 2023 19:38:42 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stefan Schmidt <stefan@datenfreihafen.org>
Cc:     davem@davemloft.net, pabeni@redhat.com, linux-wpan@vger.kernel.org,
        alex.aring@gmail.com, miquel.raynal@bootlin.com,
        netdev@vger.kernel.org
Subject: Re: pull-request: ieee802154 for net 2023-03-24
Message-ID: <20230327193842.59631f11@kernel.org>
In-Reply-To: <20230324173931.1812694-1-stefan@datenfreihafen.org>
References: <20230324173931.1812694-1-stefan@datenfreihafen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 24 Mar 2023 18:39:31 +0100 Stefan Schmidt wrote:
> An update from ieee802154 for your *net* tree:
> 
> Two small fixes this time.
> 
> Dongliang Mu removed an unnecessary null pointer check.
> 
> Harshit Mogalapalli fixed an int comparison unsigned against signed from a
> recent other fix in the ca8210 driver.

Hi Stefan! I see a ieee802154-for-net-2023-03-02 tag in your tree but
no ieee802154-for-net-2023-03-24:

$ git pull git://git.kernel.org/pub/scm/linux/kernel/git/wpan/wpan.git \
	tags/ieee802154-for-net-2023-03-24 
fatal: couldn't find remote ref tags/ieee802154-for-net-2023-03-24
