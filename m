Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A43341BD138
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 02:37:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726381AbgD2AhU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 20:37:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726345AbgD2AhT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 20:37:19 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A47B6C03C1AC;
        Tue, 28 Apr 2020 17:37:19 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id hi11so47984pjb.3;
        Tue, 28 Apr 2020 17:37:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ptJeGTLaFyRQbL22RC6YhHKsNcb/p6+6SrbV14+X+ug=;
        b=Y0AWPD8Nf3mEyH7hecW+3GY4I3LwR0cUl5TwBiNt8dodMDhxdgLZJaixbRUBzTAM7M
         OxFsxWL3wSVWqbKPGLBec7CWjeRjEywgvR+MLkblsazRtAIl957f1Zb9wOfJaH/tTTDD
         1EAe3uzJtCoDhsOQafC8CqsfnY1FV2M7JpWbdUvaCMxAbfVCLydWFMCxIfr2E4TnNLRI
         8bJ9fURNz9pQDNfZVAeKNrrUV4SgRnWI7oBpTz3rCxAmLKCDLO54FaA3/qe/bYXwsSV8
         /JaZbYSUYOZtEFWE3UpFczWHNCPcHJCyI4RxJ9dDekwuFi+qKo2UR8kjaXDZFdBCedkN
         MFFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ptJeGTLaFyRQbL22RC6YhHKsNcb/p6+6SrbV14+X+ug=;
        b=VFUeZeFC9TCnN9DuoYWxbBZ7uLTj0OUwQb0kETWI0ouqXB/n9QpTq4FjjSKW24sPmO
         T2NcbZ6NpzkBv/qiYbPHkjNMCfHt3dQEv9xYlKxpiCzKw5Bd97daw6nIBlH2eFGxj6YA
         NzIV4eV4PeFvJzmM2mIZ4Y+MLon9I361aQbRfcl+zgh1IXs5+AC/WgznOEpWIAd3K5h4
         ql5Ao1otytPjJdx51oomby5XLINYVbbX/WfKAM+uVIyvpbiw73j0ZsxeBRVoAmmsvky3
         GbmRLR8oDrMwifVUMVN6e/3dqxKe8IFW3ppQfGLp+Qq9BKWKDX+tfsiZNn6t2VOR+5Cw
         RLcg==
X-Gm-Message-State: AGi0PuZYqZ4GY7/4c5J3Ff5BtlnFCNSdX1cVoLnNrVAa9AR4DJxR+zL8
        /HoX00PuQ+lVBUKCOw11HgE=
X-Google-Smtp-Source: APiQypIxOPS3RJhaBEil5GwquflReABXrPXHWaMbWYkxDTO+zWNZQQ3pZr3tWaomB7I+1AoDa8o0UA==
X-Received: by 2002:a17:902:ee06:: with SMTP id z6mr15930395plb.125.1588120639180;
        Tue, 28 Apr 2020 17:37:19 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:9061])
        by smtp.gmail.com with ESMTPSA id k12sm13995591pgj.33.2020.04.28.17.37.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2020 17:37:18 -0700 (PDT)
Date:   Tue, 28 Apr 2020 17:37:15 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, toke@redhat.com, andrii.nakryiko@gmail.com,
        kernel-team@fb.com
Subject: Re: [PATCH v3 bpf-next 0/3] Add BTF-defined map-in-map support to
 libbpf
Message-ID: <20200429003715.p4xydibqfneam4uf@ast-mbp.dhcp.thefacebook.com>
References: <20200429002739.48006-1-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200429002739.48006-1-andriin@fb.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 28, 2020 at 05:27:36PM -0700, Andrii Nakryiko wrote:
> This patch set teaches libbpf how to declare and initialize ARRAY_OF_MAPS and
> HASH_OF_MAPS maps. See patch #3 for all the details.
> 
> Patch #1 refactors parsing BTF definition of map to re-use it cleanly for
> inner map definition parsing.
> 
> Patch #2 refactors map creation and destruction logic for reuse. It also fixes
> existing bug with not closing successfully created maps when bpf_object map
> creation overall fails.
> 
> Patch #3 adds support for an extension of BTF-defined map syntax, as well as
> parsing, recording, and use of relocations to allow declaratively initialize
> outer maps with references to inner maps.
> 
> v1->v2:
>   - rename __inner to __array (Alexei).

Applied, Thanks
