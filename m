Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D889E56D14B
	for <lists+netdev@lfdr.de>; Sun, 10 Jul 2022 23:00:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbiGJUzS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jul 2022 16:55:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiGJUzR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jul 2022 16:55:17 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 413E814003;
        Sun, 10 Jul 2022 13:55:14 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id g4so3217927pgc.1;
        Sun, 10 Jul 2022 13:55:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qQKjxcYz1SGrja/RVWPyvjQAdujAs0bm/5MR0Zd7Fbs=;
        b=J3T5xnG1aPiHUNRQPunaMCimNV7xGov7UtdtYdHjaMGT6u0XnG5UsGmHJSLPOKXzn8
         J7nMnII2QM10Qhl5LHKZJKUrrFFZK4V0wwUc4w3aXHt+cQcj2s55m7Kn40IYEDhUKqTb
         dSwMuwcjOEXlC4wNQ6+ODl8OgELw4mXnHHj1wrfu3Cfkdx1bgCseS64zjhFdMSRmY2pj
         HcUrWodW2cY1xOKmN5ahKPKXtkrgZWsvc99irE6xip8ou5SnXmApnqWIrCuz1kxFuz8z
         6Tm/J379p46vZwowXNbim6uD1hNpMSsNLsN7wmMbaLFyFoDLuNy5VPyF7wV8UcIBZk+b
         Gx8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qQKjxcYz1SGrja/RVWPyvjQAdujAs0bm/5MR0Zd7Fbs=;
        b=ACkb1wOseiwW2R1kVfkKp+AQ2Yo/TIhBgDwcSLXVG8oFzhznm6KN93Wpw4sGCe5Kgz
         O5j7AseyM+zpnF1/wtOwty8M6u2zkz9iVWeKZEosFz//wvPGBN5IKqrylvj8gPpRxSIV
         4kWCbix4SUs6BITHq0Iwu4r2vuk4RnQ33mNoqfoWegWsPapcKbuBAgy+OzolooOGlax9
         jjIhMQLjdwpR6IIdiiO5dibmohxBjJOl+spoFrx3NV/8qTpe1rCPlrCWDC+K+vWQKr9s
         OqaekpnFizotECDeg26pXRZYn5oMb5RXbcK2vZBg/GADD70jWkEubH4emN16Nd3hOPNt
         4xRA==
X-Gm-Message-State: AJIora/iulXxQXjpzMEgZHyoffqUAvPycxmdt/xVMPEv8UXP8SOZqb6o
        5ID57239mNNquKkWvDYUZwae7zrGNA7mqA==
X-Google-Smtp-Source: AGRyM1v/0pHHJkcEvPg32H/Zrta20c9KMIwYkT2EJglL1F4N05DErX0mIwaKlQWfsGCUQACIrQO7Dw==
X-Received: by 2002:a63:69ca:0:b0:411:994d:1e29 with SMTP id e193-20020a6369ca000000b00411994d1e29mr13517561pgc.118.1657486513481;
        Sun, 10 Jul 2022 13:55:13 -0700 (PDT)
Received: from cloud-MacBookPro ([2601:646:8201:c2e0:4045:a2e:ac7a:d1f4])
        by smtp.gmail.com with ESMTPSA id js1-20020a17090b148100b001ef7e5f2a82sm3235158pjb.25.2022.07.10.13.55.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Jul 2022 13:55:13 -0700 (PDT)
Date:   Sun, 10 Jul 2022 13:55:12 -0700
From:   binyi <dantengknight@gmail.com>
To:     Joe Perches <joe@perches.com>
Cc:     Manish Chopra <manishc@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        Coiby Xu <coiby.xu@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] staging: qlge: Fix indentation issue under long for
 loop
Message-ID: <20220710205512.GA1883@cloud-MacBookPro>
References: <20220710083657.GA3311@cloud-MacBookPro>
 <d278cf5d38235db92efa236cb1940a67e0e9a005.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d278cf5d38235db92efa236cb1940a67e0e9a005.camel@perches.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 10, 2022 at 08:28:57AM -0700, Joe Perches wrote:
> On Sun, 2022-07-10 at 01:36 -0700, Binyi Han wrote:
> > Fix indentation issue to adhere to Linux kernel coding style,
> > Issue found by checkpatch. And change the long for loop into 3 lines.
> > 
> > Signed-off-by: Binyi Han <dantengknight@gmail.com>
> > ---
> > v2:
> > 	- Change the long for loop into 3 lines.
> > 
> >  drivers/staging/qlge/qlge_main.c | 18 ++++++++++--------
> >  1 file changed, 10 insertions(+), 8 deletions(-)
> > 
> > diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
> > index 1a378330d775..6e771d0e412b 100644
> > --- a/drivers/staging/qlge/qlge_main.c
> > +++ b/drivers/staging/qlge/qlge_main.c
> > @@ -3007,10 +3007,11 @@ static int qlge_start_rx_ring(struct qlge_adapter *qdev, struct rx_ring *rx_ring
> >  		tmp = (u64)rx_ring->lbq.base_dma;
> >  		base_indirect_ptr = rx_ring->lbq.base_indirect;
> >  
> > -		for (page_entries = 0; page_entries <
> > -			MAX_DB_PAGES_PER_BQ(QLGE_BQ_LEN); page_entries++)
> > -				base_indirect_ptr[page_entries] =
> > -					cpu_to_le64(tmp + (page_entries * DB_PAGE_SIZE));
> > +		for (page_entries = 0;
> > +			page_entries < MAX_DB_PAGES_PER_BQ(QLGE_BQ_LEN);
> > +			page_entries++)
> > +			base_indirect_ptr[page_entries] =
> > +				cpu_to_le64(tmp + (page_entries * DB_PAGE_SIZE));
> 
> Better to align page_entries to the open parenthesis.
> 
> And another optimization would be to simply add DB_PAGE_SIZE to tmp
> in the loop and avoid the multiply.
> 
> 		for (page_entries = 0;
> 		     page_entries < MAX_DB_PAGES_PER_BQ(QLGE_BQ_LEN);
> 		     page_entries++) {
> 			base_indirect_ptr[page_entries] = cpu_to_le64(tmp);
> 			tmp += DB_PAGE_SIZE;
> 		}
> 
> > @@ -3022,10 +3023,11 @@ static int qlge_start_rx_ring(struct qlge_adapter *qdev, struct rx_ring *rx_ring
> >  		tmp = (u64)rx_ring->sbq.base_dma;
> >  		base_indirect_ptr = rx_ring->sbq.base_indirect;
> >  
> > -		for (page_entries = 0; page_entries <
> > -			MAX_DB_PAGES_PER_BQ(QLGE_BQ_LEN); page_entries++)
> > -				base_indirect_ptr[page_entries] =
> > -					cpu_to_le64(tmp + (page_entries * DB_PAGE_SIZE));
> > +		for (page_entries = 0;
> > +			page_entries < MAX_DB_PAGES_PER_BQ(QLGE_BQ_LEN);
> > +			page_entries++)
> > +			base_indirect_ptr[page_entries] =
> > +				cpu_to_le64(tmp + (page_entries * DB_PAGE_SIZE));
> 
> here too
> 

Ah I see, that makes sense. Thanks for reviewing!
