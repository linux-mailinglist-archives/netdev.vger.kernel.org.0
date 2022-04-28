Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7F16512970
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 04:20:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241365AbiD1CXo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 22:23:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241364AbiD1CXn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 22:23:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0412776281
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 19:20:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1C9DC60EA6
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 02:20:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D595C385AD;
        Thu, 28 Apr 2022 02:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651112429;
        bh=4qPwZ8r3TEjlrbTkrgz3wE9Mm6K8uyvlzhYlkZoOY9U=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=LT8JsNEtnsas6mawu999b7tFSyqGLICaARajGehMRznk8zLsOt1IcJBC38pzE3zS2
         nU7tAcXkAxrRsTpp4VlFDsOiMlbFa+Nm92V2eYs65+y817Y/71UfCdcZrljXaUvGQ/
         dPQa/b2mvUVLUHX993oMRqAr1NPWNtf7xPONWOW+qHwMLxNS3qc8EWDak9eiHrQSmI
         S/BE5/vEwShAiKSVtyAnuy8gK33BEo4DZ542sT6BgqVJt8UaIHBkEVqk8F2AJE9Oz3
         yh2V0c2XD2z0wY37zzVAhLVwr/9tvg5TZyVq2gGZtazMNpbsqb1mpnEJnFgdCLCS/+
         gsunf+cFBNliQ==
Message-ID: <9686f9c9-0068-0256-12da-0e7393089e27@kernel.org>
Date:   Wed, 27 Apr 2022 20:20:28 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.0
Subject: Re: [PATCH iproute2-next v3 0/2] f_flower: match on the number of
 vlan tags
Content-Language: en-US
To:     Boris Sukholitko <boris.sukholitko@broadcom.com>,
        netdev@vger.kernel.org
Cc:     Ilya Lifshits <ilya.lifshits@broadcom.com>
References: <20220426091417.7153-1-boris.sukholitko@broadcom.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220426091417.7153-1-boris.sukholitko@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/26/22 3:14 AM, Boris Sukholitko wrote:
>  tc/f_flower.c | 57 ++++++++++++++++++++++++++++++++++++---------------
>  1 file changed, 41 insertions(+), 16 deletions(-)
> 

man page update is missing and I noticed after I pushed. Please send a
patch for the man page.
