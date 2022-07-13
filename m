Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 006A95730C4
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 10:18:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235505AbiGMISY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 04:18:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234526AbiGMISH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 04:18:07 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00B93F0E0F;
        Wed, 13 Jul 2022 01:14:39 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id y9so9573826pff.12;
        Wed, 13 Jul 2022 01:14:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=e8k4niv2qxe2czoHlTxRFyZx/OzemwbGQXpmgfLUwKk=;
        b=InEZlaJiCTywsFh4q0qQtJ1lIvFewS4ursq2YyRdhUsW+1KoTxurL88xLnon3lZFMg
         2dwP4zMadUz1wUb3QAVNrfbWCGJUOEBkgcfKIx9zYWV2WaVm9HlCYuKWafdq5Y/q0aTX
         +SbGNqe5i/PxS9HHlGg5+zLdZXRX4E103EklQgDBTcZrtuMvnfE+CH1m8Vv9zplBOr8e
         uyavXrHJj3ZIb9YTqMrbto7RdZCRI9FEjh4UguvSkleEexfLtqeHxj2CjiRJU7CNNjBn
         Chj5D6ooeno7IpzbJsSDDakn6vewlQUzI14hxMfPKnZemA+je1SkQ0Ws9dm5VfCBo+n2
         bcEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=e8k4niv2qxe2czoHlTxRFyZx/OzemwbGQXpmgfLUwKk=;
        b=1zzQP5PTtJRcHP4f9/cqS3pXf4QsVKVPZxbSSQ7KMq8Vz5Se/A4cFE7C5O2Uk+Oday
         0BpH6gVjp+G4D39UVYTSBzy4HdH7iLud/crLBnyH/M4hsyr/dwHkUauI+ZQ42DIl7036
         iaYyq3vlIS9nGQknW8hH2pwcCVydSnwfC5+6UkO4s9dfIhLv2suIRIdE5atUt5zF/bUC
         phAUNYY8HwCiY6T/RcyspWy2Rpf9Lk7RNF7btZw5lQk80VDJha782Q9v64P0VGt8Px1s
         IgPW75SW6ZVKJy49l+0cotph4WDd82d1Y15NRtrWJ/TDBhErUGS0edrFbI+3WBlknWY1
         WFjQ==
X-Gm-Message-State: AJIora+0b5cEpDQBw4HKF81KtT4JbFB+5v2CWLqyY7K3a2Vc19yk6Tfk
        DvTHDCMcvLxhUacO9y/MgBNP5sqIs0gH9g==
X-Google-Smtp-Source: AGRyM1uxZ0wSW+q5pg5KKMeSoo9+tXDBz9FGE9U5C+xO03r/IJbQRYhA8osPYTxUu749ZipXBeHPFw==
X-Received: by 2002:a05:6a00:1a0e:b0:52a:cef3:b4a1 with SMTP id g14-20020a056a001a0e00b0052acef3b4a1mr1956752pfv.23.1657700076405;
        Wed, 13 Jul 2022 01:14:36 -0700 (PDT)
Received: from cloud-MacBookPro ([2601:646:8201:c2e0:5ee1:7060:fe1d:88a2])
        by smtp.gmail.com with ESMTPSA id l15-20020a17090a384f00b001ef81574355sm957834pjf.12.2022.07.13.01.14.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jul 2022 01:14:36 -0700 (PDT)
Date:   Wed, 13 Jul 2022 01:14:34 -0700
From:   binyi <dantengknight@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Joe Perches <joe@perches.com>, Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com, Coiby Xu <coiby.xu@gmail.com>,
        netdev@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] staging: qlge: Fix indentation issue under long for
 loop
Message-ID: <20220713081434.GA20416@cloud-MacBookPro>
References: <20220710210418.GA148412@cloud-MacBookPro>
 <YsvZuPkbwe8yX8oi@kroah.com>
 <93dc367b01cdfbb68e6edf7367d2f69adfb5d407.camel@perches.com>
 <Ys1Chwsa6e9EjRNs@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ys1Chwsa6e9EjRNs@kroah.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 12, 2022 at 11:44:39AM +0200, Greg Kroah-Hartman wrote:
> On Mon, Jul 11, 2022 at 01:55:24PM -0700, Joe Perches wrote:
> > On Mon, 2022-07-11 at 10:05 +0200, Greg Kroah-Hartman wrote:
> > > On Sun, Jul 10, 2022 at 02:04:18PM -0700, Binyi Han wrote:
> > > > Fix indentation issue to adhere to Linux kernel coding style,
> > > > Issue found by checkpatch. Change the long for loop into 3 lines. And
> > > > optimize by avoiding the multiplication.
> > > > 
> > > > Signed-off-by: Binyi Han <dantengknight@gmail.com>
> > > > ---
> > > > v2:
> > > > 	- Change the long for loop into 3 lines.
> > > > v3:
> > > > 	- Align page_entries in the for loop to open parenthesis.
> > > > 	- Optimize by avoiding the multiplication.
> > > 
> > > Please do not mix coding style fixes with "optimizations" or logical
> > > changes.  This should be multiple patches.
> > > 
> > > Also, did you test this change on real hardware?  At first glance, it's
> > > not obvious that the code is still doing the same thing, so "proof" of
> > > that would be nice to have.

I don't have access to a real hardware, so can't provide a "proof" of that.
I agree with Joe that's the same logic, and it compiles ok. But I
understand if you don't apply this patch, it's more safe with some
testing.

> > 
> > I read the code and suggested the optimization.  It's the same logic.
> > 
> > 
> 
> I appreciate the review, but it looks quite different from the original
> so it should be 2 different patches, one for coding style changes, and
> the second for the "optimization".
> 
> thanks,
> 
> greg k-h

Thank you for the review. I sent a patchset, following the instruction
here:
https://kernelnewbies.org/FirstKernelPatch
And I didn't find a good way to send a patchset by mutt in a single
command, so I run "mutt -H PatchFile" several times to send it, and I hope
that is okay.

Best,
Binyi
