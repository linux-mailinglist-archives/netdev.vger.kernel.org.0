Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6001C51FD5
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 02:17:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727174AbfFYAQr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 20:16:47 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:46141 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726378AbfFYAQr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 20:16:47 -0400
Received: by mail-qt1-f193.google.com with SMTP id h21so16484545qtn.13
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 17:16:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=EM1sHTb4zG9rzOsfZpj+Rl40vJ33A4nYRH85U9OYa4o=;
        b=vP3hdX0UZAuxL7PIrF24Xy48gYoOdqyRm2KEde5SC+iw+2LYtZMwnV/XDMbavLGB/H
         l/X8fjPZ1KatS9lGqw3LScg83w7lA6Rugu7IGN+6cjRbFsTbR9eN0AY1H4YgaNQh4M/g
         uakPgOJIluhDZhld8zIZznBDyqjSCDibUxNFrnvrIKqpRw3tAiD+qvj/FlUNK6wXv1cO
         vMscE+9nN4fq7lbCsghvGRHG2s2Wivc5NRjucTT2+eSgjb1yhZIOy/k+rkaI/Vhh3U4E
         FsDDvz/K0CGVeOz70y6cNRgti3aL8eKhnph0oIjUd0UMpoo5nn82mjrrbL83QD5/ZD70
         dmyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=EM1sHTb4zG9rzOsfZpj+Rl40vJ33A4nYRH85U9OYa4o=;
        b=r3cAY5fEyaJXkgRGbJe1WPrNZ29OSV7lxlO5em3BopQ19KYb4PHVba7OEV2Oe4bHH/
         yGqNGeIaz9TCXF4ywmxkzTih85EEkUd0TCP3vbEholfSEcQ5l5PJie2F8ZKzoVyj9IhE
         Qbm7lGrMkKckxN2EAm5Cf+/jhpGEpy5kYdopkhmQ8bRDDabFuPnOtO7mX3HUUvHJsu5o
         h9Bcb9wr4c3IgPvm2IofAELgCxi5YvcZFi8/qwgKKRXPDCKneYs7cbq897Rv2QSNncUG
         6B2UnxJiU00vdPt9cu+v51Vub3YAVbqGduNubveQdrjVKyu0s3bie1JimS8T/sIjPJgU
         260Q==
X-Gm-Message-State: APjAAAUEhcyvZ14aEAGxHe3vflZnfnnLX/8Hv8A4C5RwP4XxaIxkgXju
        T993zC1fp9ZPp4b5yAABByqFsw==
X-Google-Smtp-Source: APXvYqw9DtejGq/nZJAFngBZIkZ6tQUOllRa4pUD5GWKt00CWr4gGt0hr/nFSVX9dh95LEKP4Y4y/A==
X-Received: by 2002:ac8:28fc:: with SMTP id j57mr64857829qtj.330.1561421806028;
        Mon, 24 Jun 2019 17:16:46 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id i1sm7106403qtb.7.2019.06.24.17.16.44
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 24 Jun 2019 17:16:45 -0700 (PDT)
Date:   Mon, 24 Jun 2019 17:16:41 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Alexei Starovoitov <ast@fb.com>
Cc:     Andrey Ignatov <rdna@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Takshak Chahande <ctakshak@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        Stanislav Fomichev <sdf@google.com>
Subject: Re: [PATCH bpf-next] bpftool: Add BPF_F_QUERY_EFFECTIVE support in
 bpftool cgroup [show|tree]
Message-ID: <20190624171641.73cd197d@cakuba.netronome.com>
In-Reply-To: <97b13eb6-43fb-8ee9-117d-a68f9825b866@fb.com>
References: <20190621223311.1380295-1-ctakshak@fb.com>
        <6fe292ee-fff0-119c-8524-e25783901167@iogearbox.net>
        <20190624145111.49176d8e@cakuba.netronome.com>
        <20190624221558.GA41600@rdna-mbp.dhcp.thefacebook.com>
        <20190624154309.5ef3357b@cakuba.netronome.com>
        <97b13eb6-43fb-8ee9-117d-a68f9825b866@fb.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 24 Jun 2019 23:38:11 +0000, Alexei Starovoitov wrote:
> I don't think this patch should be penalized.
> I'd rather see we fix them all.

So we are going to add this broken option just to remove it?
I don't understand.  
I'm happy to spend the 15 minutes rewriting this if you don't 
want to penalize Takshak.
