Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEA8A85A44
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 08:10:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730934AbfHHGJt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 02:09:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:60214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726187AbfHHGJt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Aug 2019 02:09:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF2D32186A;
        Thu,  8 Aug 2019 06:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565244588;
        bh=V0IGGKZJxEdUkjdotGPslilaf3h8Z7VHCP72GlnYyqg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Xm4dzyLKbuRe068j/bDR4e+aMlXqv085JUE0lTHgppE+6Oi7c534/KaCD4vOYPWy7
         oU0Ff9+7PZkU4dMah7zhB6qVZ4DYkTALbfydhJlVNo88nyyDthaYLPdMGKc1hEeSPi
         lUz2dYzEt5mH7jHZzolQTyAEAz4j7JX+oHZAycF0=
Date:   Thu, 8 Aug 2019 08:09:46 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, yhs@fb.com, andrii.nakryiko@gmail.com,
        kernel-team@fb.com,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>
Subject: Re: [PATCH bpf-next] btf: expose BTF info through sysfs
Message-ID: <20190808060946.GB25150@kroah.com>
References: <20190807183821.138728-1-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190807183821.138728-1-andriin@fb.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 07, 2019 at 11:38:21AM -0700, Andrii Nakryiko wrote:
> Make .BTF section allocated and expose its contents through sysfs.

Ah, found the original of this, sorry for the noise on the previous
response...

Still need Documentation/ABI/ entries though :)

thanks,

greg k-h
