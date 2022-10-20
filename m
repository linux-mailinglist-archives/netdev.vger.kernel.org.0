Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F24B66060DC
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 15:02:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230313AbiJTNCg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 09:02:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230300AbiJTNCY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 09:02:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0690D58065;
        Thu, 20 Oct 2022 06:02:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 91DD5B82648;
        Thu, 20 Oct 2022 13:02:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97E80C433D7;
        Thu, 20 Oct 2022 13:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666270937;
        bh=1K64PX9tOX5Ca6uSwNh6+1ofi0n1sdorPEhGraCm6jc=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=mZInMfiakP+mLe5zPuRzkdHu8xnd5E7QHLtNLSm4Tjwsrm4p+ShzW4G/9LK8pfg5E
         rPIVu4vpygnZFXAPrdT1ni2TGbafIsS0+JLlU0w6Ro8HEhVkSUzKjho6cBSd4tzPSG
         EJQPAv4tilFBP0R7AyIaPWvPp2Ke92STNeuBGBD6D0F/t4ph3ZoZ5OLdwp60wKMfRq
         SbzVyb0ToLHuOjFYENHl5J/Dmsf4uaTsOyn/RcyD14QSMycckFQoH3WwvFVWKX/nUQ
         UsWdWl+zR1cybV8RKRFjVLhaCrw190Xhk5Tgs+gVRuhQu7gIkRI4LSH/+7I5M80yiH
         P0oKbZA5iJwDA==
From:   =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>, maciej.fijalkowski@intel.com,
        magnus.karlsson@intel.com
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>, netdev@vger.kernel.org,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org
Subject: Re: [PATCH net-next v3 00/12] net: dpaa2-eth: AF_XDP zero-copy support
In-Reply-To: <20221019155405.5d570b98@kernel.org>
References: <20221018141901.147965-1-ioana.ciornei@nxp.com>
 <20221019155405.5d570b98@kernel.org>
Date:   Thu, 20 Oct 2022 15:02:13 +0200
Message-ID: <87fsfi8x7u.fsf@all.your.base.are.belong.to.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:

> On Tue, 18 Oct 2022 17:18:49 +0300 Ioana Ciornei wrote:
>> This patch set adds support for AF_XDP zero-copy in the dpaa2-eth
>> driver. The support is available on the LX2160A SoC and its variants and
>> only on interfaces (DPNIs) with a maximum of 8 queues (HW limitations
>> are the root cause).
>
> AF_XDP folks, could you take a look?=20

Sorry for the delay, Ioana and Jakub! We'll make sure it's reviewed, but
it might take a few more days!


Bj=C3=B6rn
