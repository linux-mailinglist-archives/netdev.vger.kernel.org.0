Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEC8A690FBE
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 19:00:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230166AbjBISAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 13:00:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbjBISAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 13:00:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FD5B2823C;
        Thu,  9 Feb 2023 10:00:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D11E3B8227E;
        Thu,  9 Feb 2023 18:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BDADC433EF;
        Thu,  9 Feb 2023 18:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675965612;
        bh=hvb5u5PHA2QiRpKZ5qQF2hvV3sPOEQyZONS2dGB6vRw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DdM/JSMjjA9+W3xJZSCp4m5ffoWk4/ZOnd9JYKjUTyTKvWoE/dwsuxcaQDLFvAg71
         HNfCBFOdDk+f+YmM+BEZMZEn8V18b7uE8+hLV5hx7tWCgirOWWcDJyLa07kCl7blgN
         le/SFapCaEtywrfihYn1sMQIakrHg1l1gHqCxUHs4dxCxrziHNivBDG/RHZWPJBda/
         +rdSNWYpHRh7BAbrZqWPqnwoEnlusXTUqfjgLOw2N9RNY8iZex6g8YeV0bZR7y+0kN
         yUUBMaB8l58pzOynP6eHno/UXhnEq1L1D/pWgo62fXD+0mTKWw8Pe/h2aku4nx2P8e
         POnBnT6e3wzfA==
Date:   Thu, 9 Feb 2023 10:00:10 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     "Zaremba, Larysa" <larysa.zaremba@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "intel-wired-lan@osuosl.org" <intel-wired-lan@osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "Lobakin, Alexandr" <alexandr.lobakin@intel.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>
Subject: Re: [PATCH net] ice: xsk: Fix cleaning of XDP_TX frames
Message-ID: <20230209100010.4a1f634c@kernel.org>
In-Reply-To: <a2af75b3-3dc2-0e83-558f-2b9a4ccfe5c7@intel.com>
References: <20230209160130.1779890-1-larysa.zaremba@intel.com>
        <a2af75b3-3dc2-0e83-558f-2b9a4ccfe5c7@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 9 Feb 2023 09:20:27 -0800 Tony Nguyen wrote:
> Since it's been tested and reviewed, did you want to take this directly?
> 
> Acked-by: Tony Nguyen <anthony.l.nguyen@intel.com>

Sure thing! Already missed today's PR tho.. :(
