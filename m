Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73717139F60
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 03:15:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729575AbgANCPE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 21:15:04 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:37636 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729563AbgANCPE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 21:15:04 -0500
Received: by mail-pj1-f65.google.com with SMTP id m13so5134888pjb.2;
        Mon, 13 Jan 2020 18:15:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=nwClbXvQxL25tRyFJwdIBDnN18Dn8tE4n3efxkgHgyg=;
        b=VMLRRGFDre2eLfMT8IOqjnbZucEej3hPPdEiSa7aWD3fRktzw6CU3bT/EUFyrifs9u
         A3xJ9OOmlbT/p0XT7+vccNrORnKUxWs1c0HWT7mETAPmNtdODZVZoto40oQNJ1AnLATG
         bIM/FIbvIlSGa1Wa2HUlQxnL7vwI1MvZgLsCLK6BoRZAZd8cw/EAV8B3V/CapRaMMkFR
         aAyTRAsmwW15f7aEGCdE8T7D/oTK3XgXvDMsth87k5R8bKvJyIAptI02+SG0xYRfzA3x
         G3ulduTXkgYCQDstSUb20fMiMjBHpc9MqgvzrfWHN8BzdTVkCI48H8G/gLO7WPh9+KMO
         hPTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=nwClbXvQxL25tRyFJwdIBDnN18Dn8tE4n3efxkgHgyg=;
        b=VMJULgw7zRLc6o5Y1T4fxpknFY7FV3fpKynhAaHe/sHDUYC4zQcpjhALs2mJwp9/Vx
         5QQlBOa321Gz18CXioAelmgH4S0J7rqfcpVAtpLm+eJsFtKn8YgBYaOM5P1dzrRgL1Re
         HyvvJGmB0GBppmr6bEMaX0jKd0qd6ekkZS4dR8ySVB9OzWOpQNQ/UJndJyZgASk3RtCi
         8Kz6thLrQBVssWARtloI9ldSkKUB2egvnB5uKQtr7qhl2SDMFXbWbpMNQBGv9U71lRPj
         8QaB19Be2yPa2fI7JE1k+oFYJeUKbQwL5ZGUT/X3pfNRbLXuyrR2rlwA5QRp0C0KTxX6
         vwDw==
X-Gm-Message-State: APjAAAUxn9+vUQDmdLkVasUIzOdbzUYxIhkTWOtDjdQLkAPo9txaxEoH
        AMDEYPrA+6Faugo4psO43e4=
X-Google-Smtp-Source: APXvYqzC1xVqj5oysP73wb0uwn9HCSlLIwzu/O5Clef1kdWahR3nVugRYSIika83Q2HUDmUc46ziDw==
X-Received: by 2002:a17:90a:da03:: with SMTP id e3mr12853498pjv.100.1578968103134;
        Mon, 13 Jan 2020 18:15:03 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:180::4db3])
        by smtp.gmail.com with ESMTPSA id t23sm15975406pfq.106.2020.01.13.18.15.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 13 Jan 2020 18:15:02 -0800 (PST)
Date:   Mon, 13 Jan 2020 18:15:00 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, andrii.nakryiko@gmail.com, kernel-team@fb.com
Subject: Re: [PATCH v2 bpf-next 0/6] Implement runqslower BCC tool with BPF
 CO-RE
Message-ID: <20200114021459.jjw27v7fdt4f7aza@ast-mbp.dhcp.thefacebook.com>
References: <20200113073143.1779940-1-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200113073143.1779940-1-andriin@fb.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 12, 2020 at 11:31:37PM -0800, Andrii Nakryiko wrote:
> Based on recent BPF CO-RE, tp_btf, and BPF skeleton changes, re-implement
> BCC-based runqslower tool as a portable pre-compiled BPF CO-RE-based tool.

Looks great. Built it on one kernel and tested on another. CO-RE works :)
Hopefully more tools will be written this way.
Applied. Thanks.
