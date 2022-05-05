Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E18351C498
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 18:06:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381641AbiEEQJd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 12:09:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359063AbiEEQJb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 12:09:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADC145BE71;
        Thu,  5 May 2022 09:05:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6A077B82DBE;
        Thu,  5 May 2022 16:05:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE83BC385A4;
        Thu,  5 May 2022 16:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651766748;
        bh=EEA1O4N0n15JXNsJ1T9rmOCW+SYTC9F1on1m41VDTZM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qcS38ut8ju+Qv2rq5C7lwjJb6JYjwtuiaoV0VbiTU5lXyzjtbLl+M4Iu/Fl9b4Opz
         H4714jqS5ZFJXcB8seYjMCajXNUiyLjidCBZbyQhPNK5btLnlCIzeZ2A6btKVM5R9z
         tn1UX0n8E0PKlsKJatBxW5tTAtDvmaEo7JMAFK5+BOrOTKPts8kt4uAINqvVqHaODF
         J2qwIqrMIYRszJwq3Yx7CV/fffBtuP32TEV+cqMNl8riB/lu78a7btJIqBvfUKH3Bs
         awKhs7oxi8IMMR/KnefxYNA4rYQY4U8iAFamaaV0eLQOZKnpocVlASDn7UtgJayiu3
         8yEKGorsrsgbw==
Date:   Thu, 5 May 2022 09:05:46 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Carlos Fernandez <carlos.fernandez@technica-engineering.de>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Carlos Fernansez <carlos.escuin@gmail.com>,
        "carlos.fernandez@technica-enineering.de" 
        <carlos.fernandez@technica-enineering.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net/macsec copy salt to MACSec ctx for XPN
Message-ID: <20220505090546.3d38716d@kernel.org>
In-Reply-To: <20220505090432.544ce339@kernel.org>
References: <XPN copy to MACSec context>
        <20220502121837.22794-1-carlos.escuin@gmail.com>
        <f277699b10b28b0553c8bbfc296e14096b9f402a.camel@redhat.com>
        <AM9PR08MB6788E94C6961047699B20871DBC29@AM9PR08MB6788.eurprd08.prod.outlook.com>
        <20220505090432.544ce339@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 5 May 2022 09:04:32 -0700 Jakub Kicinski wrote:
> > CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you recognize the sender and know the content is safe.  
> 
> You'll need to make a fresh posting without this quote and the legal
> footer. Posting as a new thread is encouraged, you don't need to try
> to make it a reply to the previous posting.

Ah, you already did that.
