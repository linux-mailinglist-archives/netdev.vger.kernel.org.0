Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CE516C38A5
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 18:52:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229912AbjCURwU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 13:52:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229834AbjCURwT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 13:52:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B116B532B6
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 10:52:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 400F961D79
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 17:52:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58726C433D2;
        Tue, 21 Mar 2023 17:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679421124;
        bh=nkNp6dCDLADE//B1wXaWjXqjWuenmND8o37eqNTrhjk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Nvps22nrCN/mVFQUqPasDaVwSFtCbdX2B85RoYos+mjcvmzNm0JiPVA41I0EVUhTz
         7j1udc8CcfA7PJTKJ+Q0l2qbq7532mo0jPGMU+2sjjArvQTuFQTiQgQiQXs3fuLRoB
         aG6nYGa49si5V55hE3rgo9Bn6pzVNN/2+w0A4s7oEpbLqcV+8g/qjuaMGMQY3bxMr0
         u1xNhegA/Xu4UB3NtJYOtTxEQaa8LSQ4Fs3Ei/JxKtiN5ZP3Mxs2Y6iXp8674TKkEx
         6ZGS54lDvrgeXEqRjQltj4u1ymjb69TrFSyBLKmWlwulQwOS60LCysHeWQxw+hClMV
         QMWEP7AwijN0g==
Date:   Tue, 21 Mar 2023 10:52:03 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Michalik, Michal" <michal.michalik@intel.com>
Cc:     Edward Cree <ecree.xilinx@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
Subject: Re: [PATCH net] tools: ynl: add the Python requirements.txt file
Message-ID: <20230321105203.0dfc7a00@kernel.org>
In-Reply-To: <BN6PR11MB41770D6527882D26403EF628E3819@BN6PR11MB4177.namprd11.prod.outlook.com>
References: <20230314160758.23719-1-michal.michalik@intel.com>
        <20230315214008.2536a1b4@kernel.org>
        <BN6PR11MB41772BEF5321C0ECEE4B0A2BE3809@BN6PR11MB4177.namprd11.prod.outlook.com>
        <560bd227-e0a9-5c01-29d8-1b71dc42f155@gmail.com>
        <BN6PR11MB41770D6527882D26403EF628E3819@BN6PR11MB4177.namprd11.prod.outlook.com>
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

On Tue, 21 Mar 2023 12:34:50 +0000 Michalik, Michal wrote:
> > Assuming the libraries are following best practice for their version
> >  numbering (e.g. semver), you should be able to use ~= ('compatible
> >  version' [1]).
> > For example, `jsonschema ~= 4.0` will allow any 4.x.y release, but
> >  not 5.0.0 since that could have breaking API changes.
> > I would recommend against pinning to a specific version of a
> >  dependency; this is a development tree, not a deployment script.
> 
> This is actually a good idea. Let's wait for Jakub to confirm if he feels
> the Python requirements file is a good idea in this case. If he confirms,
> I would update the libraries according to your suggestion. Thanks.

Given the "system script" nature of the project (vs "full application")
I don't find the requirements to be necessary right now. But I don't
know much about Python, so maybe Ed can make a call? :D
