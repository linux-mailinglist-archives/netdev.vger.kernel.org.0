Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE0258AC3C
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 02:53:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726890AbfHMAxO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 20:53:14 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:39598 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726864AbfHMAxN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 20:53:13 -0400
Received: by mail-qt1-f196.google.com with SMTP id l9so104721722qtu.6
        for <netdev@vger.kernel.org>; Mon, 12 Aug 2019 17:53:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=2M1ROsoAIRUHgz5NlBMiOfhx0mbYN03KLBCffNJ0NhM=;
        b=XM0veGufoHI1pFpxVDqyfWgmn6xjgW/RKHCac6K3DgQFqo3awqUfjAX6P+CDEbp4qS
         i8BvdfVFPLv06MwW6/PTr4GX9q4+Oh7/QMZTwN6siSsWoDegjjeYfJkVn6Qq+CiUOFOH
         BzOTYGPkBUIq/nD/0dsBPTDESeOygVA5OMujuzdoBG3XaAa5EDwRGUJiuYD19O/XfQw4
         EfGcXUAV+E+9glIEeOuHEG7sKts3ZGQ2ScIwaaqSjWucvl5sQY/PD8xnpBugaUSWsWyT
         1lsO44LoKDKuTGIQ9Gz1HDJ4HfOofKAcqzLePP75Ej0Xw9sOkd92U/Tk/s0a1ilidhK3
         9viQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=2M1ROsoAIRUHgz5NlBMiOfhx0mbYN03KLBCffNJ0NhM=;
        b=h2dIz9wucNnHXLp9XXflTVVKITQxRYS+mVXGX4GE2o9KwpAjtfT3p2I2jCPbkKyViL
         2Kpl8nmK73wnuU6bUNfxDQ5TT4Qg2/KHtlJQDuCR7nxymvt/OG+SUvoFsxTMdnJ29lKD
         h5GWSFfOe3A+6ypbUz+1Cpif008lmZq6sYW6btbonXnymB9NPDnAb/k8cZ07eBDVZf8I
         Xe/f8z7xIWtw9SBk7OurSFvlCxRgwR7ODMXdImfyBpoiTW/2xPEoix8jq6dFJ8wC/JQ8
         ZlDzpq/UPFKKLhxCjVEHaCFgG04jsaZ+YvXAYBDRAZWFOAMpsQRD4+AGVEzLEoPeYmBR
         +2PA==
X-Gm-Message-State: APjAAAUdF53eu0JWrBbflqHekxT2ljqf9u65MDh5cWvayNl1beXOYFIW
        32kSNUKtpgimBkDigz20QJrG0w==
X-Google-Smtp-Source: APXvYqy2GejT7XK7vVKWcr95s5VoitAHf/Y5ftZR5gmHglHygfQk1pCHKjufjiDpKRNNYQUro+69ZQ==
X-Received: by 2002:aed:2fe7:: with SMTP id m94mr15601807qtd.125.1565657592512;
        Mon, 12 Aug 2019 17:53:12 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id b123sm6615976qkf.85.2019.08.12.17.53.11
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 12 Aug 2019 17:53:12 -0700 (PDT)
Date:   Mon, 12 Aug 2019 17:53:02 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Peter Wu <peter@lekensteyn.nl>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Stanislav Fomichev <sdf@google.com>,
        Alexei Starovoitov <ast@kernel.org>, netdev@vger.kernel.org,
        Quentin Monnet <quentin.monnet@netronome.com>
Subject: Re: [PATCH] tools: bpftool: add feature check for zlib
Message-ID: <20190812175302.54d6ef59@cakuba.netronome.com>
In-Reply-To: <20190813003833.22042-2-peter@lekensteyn.nl>
References: <20190813003833.22042-1-peter@lekensteyn.nl>
        <20190813003833.22042-2-peter@lekensteyn.nl>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 13 Aug 2019 01:38:33 +0100, Peter Wu wrote:
> bpftool requires libelf, and zlib for decompressing /proc/config.gz.
> zlib is a transitive dependency via libelf, and became mandatory since
> elfutils 0.165 (Jan 2016). The feature check of libelf is already done
> in the elfdep target of tools/lib/bpf/Makefile, pulled in by bpftool via
> a dependency on libbpf.a. Add a similar feature check for zlib.
> 
> Suggested-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> Signed-off-by: Peter Wu <peter@lekensteyn.nl>

Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>

Thanks!
