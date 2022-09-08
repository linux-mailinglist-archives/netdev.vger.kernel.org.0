Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0C065B2939
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 00:28:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbiIHW2S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 18:28:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiIHW2O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 18:28:14 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0311E7CB43
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 15:28:14 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id l65so19342991pfl.8
        for <netdev@vger.kernel.org>; Thu, 08 Sep 2022 15:28:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=e3Q7V+SDyMEqI3jKO7tZ5b0PSMS9mc0xRX8MPavD87c=;
        b=onMReWRrsK428N2jaV5hd5wec0z4ww0EA1KWEiADEwO+w7OVreVQtgDN9NF/0TX25d
         GJyEhRiLbPI9HMqrAuWkHQEF0pl615AiqixNF0tsqCxiIaOWnU5YRav1fba7s3cmj7L7
         iYBIj1JUW/1ySNjTio3xmCWUewPGuyS/fj69woKSKTsUEHCPrk7Fgwob3THVJIgDKGOh
         TbJW/bIdyWOzrxUNbiBpnP1SCN7b1Ytcc6SHjsaP1iP/e1frWbhfZEIkBASzudWKe72r
         Ztxuodtt+DiOsC1m78ZpN2Thid9EWA3p7J3jOKQDLWg9k9VbDqJyUz5geSeD7tnJvxuy
         SIwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=e3Q7V+SDyMEqI3jKO7tZ5b0PSMS9mc0xRX8MPavD87c=;
        b=yIGxeL5nK7nG01s4nLSFKG3uCHmXek3oQ6STKJEwAKCij9da6eh2541l8AFqtXtBV4
         0fA8C/lQdVTJjuJ5ucgH1vvlD0bjgzasS6fQMLHBMbsCYxA1RXkzAZTecMZIEeygzo3+
         RTuocKNP+Zt35wODxUcIWnGJiitJaS5joWqWsX9BFy7mZzi/UXDJw/TH3WKkstYqLmk5
         B6DJCFYeeZePcRslNXVmMpZL0R9GIxl51TcJwzFCSig5KKMrD0mCNHAzQIc7uRSMDMpB
         G4l3Bd+Va6CrV+9FEUUumOd73PQD1KzUko19YXgutEY4QdnEa492TRi2WBsQSkvek1o0
         A8ag==
X-Gm-Message-State: ACgBeo1YYwoMA3M0S5LjUVS2BMmrhmO+8fz2H1j+Yza6e8/LK0quJL3f
        w89r2QbHmW/UkwsyjhLXpO+5KcJHQVo=
X-Google-Smtp-Source: AA6agR5JtcDRDvMaSHDm/fLMEiR/QAFi64EH53EsqKNJ1cv8BApSUxUhE2CiCAzyXYCLBCxJXdr5Yg==
X-Received: by 2002:a63:5702:0:b0:42a:b77b:85b3 with SMTP id l2-20020a635702000000b0042ab77b85b3mr9276388pgb.263.1662676093332;
        Thu, 08 Sep 2022 15:28:13 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id b6-20020a170903228600b00177f25f8ab3sm32018plh.89.2022.09.08.15.28.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 15:28:12 -0700 (PDT)
Date:   Thu, 8 Sep 2022 15:28:10 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Lasse Johnsen <lasse@timebeat.app>
Cc:     netdev@vger.kernel.org, Tony Nguyen <anthony.l.nguyen@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        "Stanton, Kevin B" <kevin.b.stanton@intel.com>,
        Jonathan Lemon <bsd@fb.com>
Subject: Re: [PATCH net-next 1/1] igc: ptp: Add 1-step functionality to igc
 driver
Message-ID: <YxpsejCwi8SfoNIC@hoboy.vegasvil.org>
References: <44B51F36-B54D-47EB-8CDD-9A63432E9B80@timebeat.app>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <44B51F36-B54D-47EB-8CDD-9A63432E9B80@timebeat.app>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 08, 2022 at 11:18:35PM +0100, Lasse Johnsen wrote:
> This patch adds 1-step functionality to the igc driver
> 1-step is only supported in L2 PTP
> (... as the hardware can update the FCS, but not the UDP checksum on the fly..)

What happens when user space dials one-step, but in a UDPv4 PTP network?

Thanks,
Richard
