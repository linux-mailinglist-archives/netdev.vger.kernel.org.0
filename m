Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9469C22C02D
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 09:53:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726618AbgGXHxO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 03:53:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726543AbgGXHxO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 03:53:14 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DEA9C0619D3;
        Fri, 24 Jul 2020 00:53:14 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id p1so4015403pls.4;
        Fri, 24 Jul 2020 00:53:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DhllsmlJrqJtt+vF1CFjnjE0j+UxQXAPuoVAk1ibCA0=;
        b=ZwEOn9Wj+1G65yRb2z4iDiijAvn79VTpRxihCXOV+bKISbfQn4SS/ZdBYy/uwIGzl2
         K7MdwR27vjN280CftvYwLzkRSweeDSJbWozD41bsCZI8n/DDqGfRqfK37GJkVyL3UAXH
         XQo0ixzpNeGOzmHoGcI34hwDQJ1asasQXnr8SVuZKvNWjKL9wYVnPP9PC/urUK/5QhTU
         cKcCl/y2faYNi1PCYhFA6mX51dbGFlmOjY60gV1pFOZHK7zX84Zo+dfe48BrtMLLJ5VQ
         XHmzkLUprTzdZWedeIvaNaGTT7GviZ1yDlBswBGcmVMoKWm9EvOoTCByJwPvnLWRByNg
         uy/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DhllsmlJrqJtt+vF1CFjnjE0j+UxQXAPuoVAk1ibCA0=;
        b=eHmawD9JOQSx7DOZCW/o8NGyZ4T6BsSLXh0ptZ5f8iFht/TflfYCfLJNEZh1BsU6/6
         OdR0W0tZpsB1q3iGvOE7RKQ3kmpk2TspjMxzwVEla3KRHrh67pY2XmhIoSyYy2bdgMrx
         bqDW3OKD0ul93u382CaMakoOfy+grxtQLKqngq7wWG5jkLlO2Zir8yQzaIRyBeMWkDMU
         es9lFOjsNyi4nuFEX8vJ7Tktr/ly4+nfynDGklixySuVw1lsKrv7tl8+jlSZyHE3bEBc
         hcVrzbSkcGRCBBGVhzeaovkAkfThWw50+Q3KLDN4ZeE1f+M5jcdm6eK7UU//IzqEP5bJ
         mJPg==
X-Gm-Message-State: AOAM530VAoAeaqgIXy9GwtMauL4d1dR878PATgf9r8GksOBdOx7uTSRP
        6WHw5SJNCm88xdgihUWvRpXusPYX8D2U2A==
X-Google-Smtp-Source: ABdhPJyJYneM6UM0rcnDkUPAq+ZkqYs1vLUKDTXcdAMK4CGYjopUvOAFqg6dKiG9sV9bchd25O5H8Q==
X-Received: by 2002:a17:902:7591:: with SMTP id j17mr7065172pll.286.1595577193965;
        Fri, 24 Jul 2020 00:53:13 -0700 (PDT)
Received: from dhcp-12-153.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id e8sm5273745pfl.125.2020.07.24.00.53.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2020 00:53:13 -0700 (PDT)
Date:   Fri, 24 Jul 2020 15:53:03 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>, ast@kernel.org
Subject: Re: [PATCH bpf-next] bpf: add a new bpf argument type
 ARG_CONST_MAP_PTR_OR_NULL
Message-ID: <20200724075303.GK2531@dhcp-12-153.nay.redhat.com>
References: <20200715070001.2048207-1-liuhangbin@gmail.com>
 <67a68a77-f287-1bb1-3221-24e8b3351958@iogearbox.net>
 <20200717091111.GJ2531@dhcp-12-153.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200717091111.GJ2531@dhcp-12-153.nay.redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 17, 2020 at 05:11:22PM +0800, Hangbin Liu wrote:
> On Thu, Jul 16, 2020 at 12:28:16AM +0200, Daniel Borkmann wrote:
> > > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > > index c67c88ad35f8..9d4dbef3c943 100644
> > > --- a/include/linux/bpf.h
> > > +++ b/include/linux/bpf.h
> > > @@ -253,6 +253,7 @@ enum bpf_arg_type {
> > >   	ARG_PTR_TO_ALLOC_MEM,	/* pointer to dynamically allocated memory */
> > >   	ARG_PTR_TO_ALLOC_MEM_OR_NULL,	/* pointer to dynamically allocated memory or NULL */
> > >   	ARG_CONST_ALLOC_SIZE_OR_ZERO,	/* number of allocated bytes requested */
> > > +	ARG_CONST_MAP_PTR_OR_NULL,	/* const argument used as pointer to bpf_map or NULL */
> > >   };
> > In combination with the set, this also needs test_verifier selftests in order to
> > exercise BPF insn snippets for the good & [expected] bad case.
> 
> Hi Daniel,
> 
> I just come up with a question, how should I test it without no bpf
> helper using it? Should I wait until the XDP multicast patch set merged?

ping?
