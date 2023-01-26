Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 562EA67D99C
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 00:30:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232149AbjAZXa1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 18:30:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229756AbjAZXa0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 18:30:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B856936474
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 15:30:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5F78F6195A
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 23:30:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 309C2C433EF;
        Thu, 26 Jan 2023 23:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674775824;
        bh=UW9clr+ltYfAI0jQcPt+Fa+sSt9EUehq9dOZRgf+dpU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XIumiY/5e6fLAdD8TYnHtn9hUrzjRqkl0ZAwEgLopH/3nNn8VXvFkmRys+hNJ5SaR
         JkJfJG87c0igJwI+6+xqikkFFrtS2Ma04G4iIOiXoggzL28iMI8VsYsjew7U5yF1N5
         zEOz78bixG4f7s4b9LpTqRNP+9tKHDGcO5qlctxjHE/HDSDXGN7TyIwWk2PIMBj6Fa
         Rxr+ryc5Epmi8GH1sVGL6ei2B3lLpSYGJU4/U88Kw0FA3upR5j7m7UZF6wG48i2o4Q
         njb/YBkXmXIiexfYXt+YwIkH5euiZ8Nn80umOwUybJuTFB+itkQwY259vc2IQiHmN+
         3/cf/oYD7JLtQ==
Date:   Thu, 26 Jan 2023 15:30:22 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     netdev@vger.kernel.org, kernel@mojatatu.com,
        deb.chatterjee@intel.com, anjali.singhai@intel.com,
        namrata.limaye@intel.com, khalidm@nvidia.com, tom@sipanda.io,
        pratyush@sipanda.io, jiri@resnulli.us, xiyou.wangcong@gmail.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        vladbu@nvidia.com, simon.horman@corigine.com, stefanc@marvell.com,
        seong.kim@amd.com, mattyk@nvidia.com, dan.daly@intel.com,
        john.andy.fingerhut@intel.com
Subject: Re: [PATCH net-next RFC 00/20] Introducing P4TC
Message-ID: <20230126153022.23bea5f2@kernel.org>
In-Reply-To: <20230124170346.316866-1-jhs@mojatatu.com>
References: <20230124170346.316866-1-jhs@mojatatu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 24 Jan 2023 12:03:46 -0500 Jamal Hadi Salim wrote:
> There have been many discussions and meetings since about 2015 in regards to
> P4 over TC and now that the market has chosen P4 as the datapath specification
> lingua franca

Which market?

Barely anyone understands the existing TC offloads. We'd need strong,
and practical reasons to merge this. Speaking with my "have suffered
thru the TC offloads working for a vendor" hat on, not the "junior
maintainer" hat.
