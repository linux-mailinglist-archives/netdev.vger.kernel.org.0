Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B58D33E8CF6
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 11:12:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236671AbhHKJNQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 05:13:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34572 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236606AbhHKJNP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 05:13:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628673171;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sBd7I4vGrlcBSrcDGWtasy0vERb3LcymHfSFBsRe8Iw=;
        b=g/82NrBF53HTHqFarqXtAEthM60I78qC66yvx09YsuRhOjGLafrkwkYiC0E/uqy22ShOts
        uOKL9pfK5/pmfwDsPsliNlEVRVtg+OqbYWjLsuwLFKIskJlp2l0kwANPOveU5P3VAU0dan
        xxYMKqiAmgAcBorRrRK2sQBX1cdKf9s=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-455-o5zJJNJzN9yWfkaUPIk5kA-1; Wed, 11 Aug 2021 05:12:49 -0400
X-MC-Unique: o5zJJNJzN9yWfkaUPIk5kA-1
Received: by mail-wr1-f72.google.com with SMTP id r17-20020adfda510000b02901526f76d738so522351wrl.0
        for <netdev@vger.kernel.org>; Wed, 11 Aug 2021 02:12:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sBd7I4vGrlcBSrcDGWtasy0vERb3LcymHfSFBsRe8Iw=;
        b=C/uYivrtJoInptLcAFrYmPhN+XWTQahcl5/iCOqfALTMUleazQC5AtIuce63WzYr4G
         X5bRy+M3OXzR3x8tlShyrwH3WM6OK+F/T1Je/g9+FSCtAmOwXzK5g90YlawrZFOUnZfI
         pcw/Qv0Rlr57ganxaEONI20d2LbZQhhmKxeZk9SwZalgs88+89CPyvZXvh3l1Uhw4zG9
         gCNAf8ADxg8LdQ+ZGtibRSTI+rIv8+0I6f5qaNXBmcy1iqnmf1l4ZUhiRuyhC4mg7rXf
         0AkD3GGmyA+PHOXr9LHo9YY8WhethM2ddER6W2Y8iM5Mbco3EYflJ1cGzYyP0RxN4qP+
         vM2A==
X-Gm-Message-State: AOAM530qyH6qrBv50vEJ4Ae53rz4dIWG6I83s5L3f2pn9lttJ60K+mK1
        coiFEB+kiKzyCTeUl44NXEK9h1OEosAPFCxWMtMPJdCf29cet/fte25s6mGFfSJjRH/lY05Ef9a
        gFL/6dRgIVHSroPYP
X-Received: by 2002:a05:6000:12cf:: with SMTP id l15mr19115004wrx.381.1628673168573;
        Wed, 11 Aug 2021 02:12:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxmT2hFpGCa+aGAaPLgvINTSALJYrvkTX466BnoRsuryoUamy/ULbVUSQ3mvS1Nyp/hzX8uKQ==
X-Received: by 2002:a05:6000:12cf:: with SMTP id l15mr19114993wrx.381.1628673168410;
        Wed, 11 Aug 2021 02:12:48 -0700 (PDT)
Received: from localhost ([37.160.135.43])
        by smtp.gmail.com with ESMTPSA id d15sm28462615wri.96.2021.08.11.02.12.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 02:12:48 -0700 (PDT)
Date:   Wed, 11 Aug 2021 11:12:43 +0200
From:   Andrea Claudi <aclaudi@redhat.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com, haliu@redhat.com
Subject: Re: [PATCH iproute2] lib: bpf_glue: remove useless assignment
Message-ID: <YROUi1WhHneQR/qz@renaissance-vector>
References: <25ea92f064e11ba30ae696b176df9d6b0aaaa66a.1628352013.git.aclaudi@redhat.com>
 <20210810200048.27099697@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210810200048.27099697@hermes.local>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 10, 2021 at 08:00:48PM -0700, Stephen Hemminger wrote:
> On Sat,  7 Aug 2021 18:58:02 +0200
> Andrea Claudi <aclaudi@redhat.com> wrote:
> 
> > -	while ((s = fgets(buf, sizeof(buf), fp)) != NULL) {
> > +	while (fgets(buf, sizeof(buf), fp) != NULL) {
> >  		if ((s = strstr(buf, "libbpf.so.")) != NULL) {
> 
> Ok. but it would be good to get rid of the unnecessary assignment in conditional as well.
> 
Hi Stephen,
That's not unnecessary, s is used as the second parameter in the following strncpy().

