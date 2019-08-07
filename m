Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACF2C853A3
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 21:33:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389212AbfHGTbO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 15:31:14 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:40162 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389098AbfHGTbO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 15:31:14 -0400
Received: by mail-pl1-f194.google.com with SMTP id a93so42203841pla.7;
        Wed, 07 Aug 2019 12:31:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=bvbPklOdUA/AqR4MNrUOI+g+38lLzjNfbXlN0TQ3HO4=;
        b=DL1BE6YMswITJ4K3VYSGzaJ6voj7yeF9q7jYt9AUZQIL1fRIzPzaJIKL1G+k+CQ+oX
         5+bA3g7HaMI5Gpus0G7A8XmxlVJabD/sJZiqLa16OwW2IWMNhQV13LKYJm5VC0FMCVvh
         DE3AgGWwEDYBpgw631/I+mye949V+mshiNMaATQo+MT2AbpESRT4254WmerIgpuz+3uh
         bwZ6zb45oJy4SAVAkAWdDzFAAwSpGi+b81noa8cCfnYXmoAL4J+UVxe+ZijW1Qnb0nsE
         SlwO8KaguQeIJQpnt75dqfiHvWlEOTvszhIxMs3T3R9T1Dq+p2o3/oPS9eHEdo1p18+q
         BDWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=bvbPklOdUA/AqR4MNrUOI+g+38lLzjNfbXlN0TQ3HO4=;
        b=bS2hnZyyZ6VhL0gtyGcDxFol+dbgxpE03uqYh6VyQShtAUEZR16rw4dCwZlQQiCLe9
         xnUMSHjwl2aLEJrVDWrFBZu//fN8FB/9gkSX9aEBUp5SZDXy7hyx1YA4Dcs7ORhSjQw1
         UJ8iS7h10IKD+xK765K6spUJnALGlmSz0ayeJ6eMmU49W8nndhB68fwLdVm5lPnRHBCZ
         92RQRLqIo++MHTUGWMwdvPT1+NSVmgoRFCHio74lSggR7zaTgni4MrwkfZPgJIP5shFQ
         Q1E5lLACzBfNQqMlZvkLmvr3HZ1EGcJkN7mIDY9jbwSwyKOGSqu7OJTJRrfe0j1ng5sO
         wIqA==
X-Gm-Message-State: APjAAAWKoxKLmFW6O6r5L5tR2NzqfnEN9i9nKJZNk1OkqcztdzqGbBdM
        B3WJJKWg1hmfEXTSudEBNTA=
X-Google-Smtp-Source: APXvYqzVWWxBBKDC7eDe35wEfCOMKHMh+IsIoVtCmPPJCXntrXo0yOLy42SyIGQ5u0Y5Q2uxmiUMfA==
X-Received: by 2002:a17:90a:270f:: with SMTP id o15mr46122pje.56.1565206273555;
        Wed, 07 Aug 2019 12:31:13 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:200::7084])
        by smtp.gmail.com with ESMTPSA id v63sm95417494pfv.174.2019.08.07.12.31.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Aug 2019 12:31:12 -0700 (PDT)
Date:   Wed, 7 Aug 2019 12:31:11 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, yhs@fb.com, andrii.nakryiko@gmail.com,
        kernel-team@fb.com
Subject: Re: [PATCH v4 bpf-next 01/14] libbpf: add helpers for working with
 BTF types
Message-ID: <20190807193110.p5flmxojmdjdg4dj@ast-mbp>
References: <20190807053806.1534571-1-andriin@fb.com>
 <20190807053806.1534571-2-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190807053806.1534571-2-andriin@fb.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 06, 2019 at 10:37:53PM -0700, Andrii Nakryiko wrote:
> Add lots of frequently used helpers that simplify working with BTF
> types.
> 
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
..
> +/* get bitfield size of a member, assuming t is BTF_KIND_STRUCT or
> + * BTF_KIND_UNION. If member is not a bitfield, zero is returned. */

Invalid comment style.

