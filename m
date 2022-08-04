Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED24958A13D
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 21:29:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240120AbiHDT3P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 15:29:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240110AbiHDT3O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 15:29:14 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F9716D54F
        for <netdev@vger.kernel.org>; Thu,  4 Aug 2022 12:29:14 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id r186so763060pgr.2
        for <netdev@vger.kernel.org>; Thu, 04 Aug 2022 12:29:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc;
        bh=7NBAD5NE5cm7rb6JhODYZEGjJRe7XAz+yMcGaqHtoMQ=;
        b=nnKGDqMUFxvm/phLTQTxdFEmWd2u/mewQDe2KMxq23CizU6dA/grGerBMJ5yW/YrdF
         aYzU6lFCsEb6ZnunUynetfzk2JSEAqnSdB6Bx+EaqIHoodNG43r86gwlEH7CmV2Ug0YG
         vxbLEQj1HhwxZ+gOPEIRAD3f3sRzGMkhfqjxxc9MqbSwliv4oDvPNp47gQqEQhNooePH
         5GU0xTi9Bhj7RHFyrxQ5P4p2N47x5My/xLr071qSuGsfPhBoWFwkPtE8Hd7YVEp2uSLa
         QGgN5T9lMoqv0+03Fq9K0D90P4xVHCGim56IrSRgILnl/oVo5XA9IgS9Yb6MvPdzCLqA
         FpHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc;
        bh=7NBAD5NE5cm7rb6JhODYZEGjJRe7XAz+yMcGaqHtoMQ=;
        b=t6a9XRq+iJBKq7GHsmBBFaGsETbn0zqjq1R2+d5LRraD1z/VWEnBmFEF1FTgICgx4B
         BnqH/FyDm+rq3O3+ZVbGNSqxL0yZ4AK400YpUogloQ7nipIvQz+7+eqOBTMm49oj/+O+
         a7uzdvzFIr2vKSc1wSrY/HJd3yn7jF+8kg0CIBdPogcME9ACr4lO2kziveDs1exuO3TU
         5WiViFuWMivg+kAonlQyORC34gjAJme/xEZcqpRq6CnBN3tTqql21aAf86mB+rOFaxR5
         POdWuIYCQE5VE0MkcfaXoJGAaCWS8u0FwmHNH9xDji3j6wzjVYiZ+rVlTCNzLT5rKgzs
         dDJQ==
X-Gm-Message-State: ACgBeo2ptfpmjjx0eE6tQx0h9JVxLAwTIJ8LD91aiL1nCq9L3fhnu/cH
        rw839Y2qZQ9UOcxfAJWn+wzWGyqdFFA=
X-Google-Smtp-Source: AA6agR5fAL1hPiJ6AJy69Bfp1DfHrDcMm6gfY4pHaa1PWRwP4snNI17ECUj+XJguJj2J+L6kIFm81w==
X-Received: by 2002:a05:6a00:b4d:b0:52b:1eb1:218e with SMTP id p13-20020a056a000b4d00b0052b1eb1218emr3289449pfo.33.1659641352197;
        Thu, 04 Aug 2022 12:29:12 -0700 (PDT)
Received: from [192.168.254.91] ([50.45.187.22])
        by smtp.gmail.com with ESMTPSA id u6-20020a17090341c600b0016be596c8afsm1274246ple.282.2022.08.04.12.29.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Aug 2022 12:29:11 -0700 (PDT)
Message-ID: <6b0d571ea5fbc5942d798d5201b2cef253688949.camel@gmail.com>
Subject: Re: [RFC 1/1] net: move IFF_LIVE_ADDR_CHANGE to public flag
From:   James Prestwood <prestwoj@gmail.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org
Date:   Thu, 04 Aug 2022 12:29:11 -0700
In-Reply-To: <20220804105917.79aaf6e9@hermes.local>
References: <20220804174307.448527-1-prestwoj@gmail.com>
         <20220804174307.448527-2-prestwoj@gmail.com>
         <20220804105917.79aaf6e9@hermes.local>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-5.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Thu, 2022-08-04 at 10:59 -0700, Stephen Hemminger wrote:
> On Thu,  4 Aug 2022 10:43:07 -0700
> James Prestwood <prestwoj@gmail.com> wrote:
> 
> > + * @IFF_LIVE_ADDR_CHANGE: device supports hardware address
> > + *     change when it's running. Volatile
> 
> Since this is a property of the device driver, why is it volatile?

Its not intended to be changed since its a device capability.


> When you make it part of uapi, you also want to restrict userspace
> from changing the value via sysfs?
> 

Yeah, this is what I intended to do. Similar to the other volatile
options. Basically following this comment:

"...few flags can be toggled and some other flags are always preserved
from the original net_device flags even if you try to set them via
sysfs. Flags which are always preserved are kept under the flag
grouping @IFF_VOLATILE. Flags which are volatile are annotated below as
such."

Thanks,
James

