Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C56F4AE357
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 23:21:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387180AbiBHWVt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 17:21:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386513AbiBHUr7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 15:47:59 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EEDEC0613CB
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 12:47:58 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id i186so646152pfe.0
        for <netdev@vger.kernel.org>; Tue, 08 Feb 2022 12:47:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=36bFG7ntm+OMXHUX1wBqy1exMKG3hT94fWkd/YdKFso=;
        b=EB5blAN+nc4047T4q3y6PAXdjFVzOh0h1nRpPlBLAymmXmt38O74ex9G1CPRcAuUmQ
         lR3NCPsglplkaB/0HuarR9qASqtbYZdgt+TwIgqgu7nIM53hudsv2Os1ctfQGikl6oGq
         hRSbGSHmA872UXys/1ZCfGw37y4TYDfbUi8B+WCHSBdgYcngBY29Rxqo4Tzl/MQ8d0bu
         X1zse1TAjgr9LLiz2qvmhUaSRluau3pFCPJjfW4Iw9TTqJGoWiKdvKX9ILFDj0V672J5
         Ji5TkgNvRg3hwzbSCz3E+xacX1aWPufZU7VAJ0fyLC/yNRoX9Jx+M/G7HJrKzddQbMqN
         JMCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=36bFG7ntm+OMXHUX1wBqy1exMKG3hT94fWkd/YdKFso=;
        b=X8HZvw5ZrJfGe2egaDDJAXoBcreNQXLNeST10tk8OUxfinXxuBmUmvSWMzv+iBG8we
         CzC81i8DfBlyaUoyLkes4z42QiTTnkq0LHlFpb+lAgdCBySjWc1E4A0g8sEuwt7Hfy0d
         tUnK/Sb+TjY1znzSg9cIkx21sSRc6z2dudk5RUxyPNA+2kg+DzIVHvnizCUVCDrQQh0n
         I9feUxIcpnIRMwoi5P1kOl2ooCdA+vTXMAU5hVUea+oOd/FiCULY7SbWyaq9JDCADdNp
         GWbSbxhLongO4NFOzQvwQ/ZsG0COuyhY0YFItAzcQcmXTwB2Hx2ZJwrcoinqAUN21NhJ
         l4DQ==
X-Gm-Message-State: AOAM532sxfP9wqB/thVedmZCyBDTdJxt6iZKaIux5Gn918Nemedf+tZG
        3+yuW5es/36r93H2MuLOi+jcrazzCV4r907U
X-Google-Smtp-Source: ABdhPJyqy4Q9iMO2ppfHSk71V5UJaaUs1WuiXDPrl5/nsYuuGQzyD72sfPcAc7NM/DGFn2r6P7IV+Q==
X-Received: by 2002:aa7:87c4:: with SMTP id i4mr6280286pfo.38.1644353277790;
        Tue, 08 Feb 2022 12:47:57 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id pg2sm4258937pjb.54.2022.02.08.12.47.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Feb 2022 12:47:57 -0800 (PST)
Date:   Tue, 8 Feb 2022 12:47:54 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Maciek Machnikowski <maciejm@nvidia.com>
Cc:     "marta.a.plantykow@intel.com" <marta.a.plantykow@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "people@netdevconf.info" <people@netdevconf.info>,
        "milena.olech@intel.com" <milena.olech@intel.com>
Subject: Re: PTP-optimization code upstreamed
Message-ID: <20220208124754.02817343@hermes.local>
In-Reply-To: <BYAPR12MB2998E6F31AAAFBDF9294A092CC2D9@BYAPR12MB2998.namprd12.prod.outlook.com>
References: <20220208132341.10743-1-marta.a.plantykow@intel.com>
        <20220208095441.3316ec13@hermes.local>
        <MWHPR11MB177519F17F8BF5145DC773BBA82D9@MWHPR11MB1775.namprd11.prod.outlook.com>
        <BYAPR12MB2998E6F31AAAFBDF9294A092CC2D9@BYAPR12MB2998.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 8 Feb 2022 19:43:13 +0000
Maciek Machnikowski <maciejm@nvidia.com> wrote:

> > -----Original Message-----
> > From: Stephen Hemminger <stephen@networkplumber.org>
> > Sent: Tuesday, February 8, 2022 6:55 PM 
> > Subject: Re: PTP-optimization code upstreamed
> > 
> > On Tue,  8 Feb 2022 14:23:41 +0100 
> > 
> > The process for contributing to upstream kernel is very well documented.
> > Links to github is useful, but does not start the upstream process.
> > 
> > https://www.kernel.org/doc/html/latest/process/submitting-
> > patches.html#submittingpatches
> > 
> > When can we expect patch set to show up on this mailing list?  
> 
> Hi Stephen,
> 
> This code is not intended to be upstreamed, since it is a set of python scripts
> optimizing phc2sys and ptp4l servo.
> It reached the netdev mail list because it was presented on the NetDev 
> conference, and some people were interested in them during the presentation.
> 
> Have a great day!
> Maciek 

Sure thanks. It still might be good to have this in tools directory.
Or somewhere related to kernel.
