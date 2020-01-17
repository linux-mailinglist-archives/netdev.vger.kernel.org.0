Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE4DE140F0E
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 17:35:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728835AbgAQQfh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 11:35:37 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:36071 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726889AbgAQQfh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jan 2020 11:35:37 -0500
Received: by mail-pj1-f67.google.com with SMTP id n59so3548875pjb.1;
        Fri, 17 Jan 2020 08:35:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Tk6HLdN1zImWu1L0zmIhWUOzNebvVonDSsfb4q+YHz8=;
        b=Jh/xNtzIiLcsPs6q+FZeQju+kqrSx/KfPbmmB1oGKz2bW5VEfQwt/SrdAetiFzYu6n
         z7ra4zR+GqaLJ1nCmwqDezn+SwPCAHM+9H2xsglKh5/3Gilq1rP5rq9nBkF62/1EoGRn
         OhAI8gv+flQ/UiMObrUYDIvJxkx0ZAMzSEFq1jd7VNFls2Pz9LbGVNEHY2fdI6O37NIL
         mgWUKIPN8L5s2Ti2MuE2r1tT5P/gbmNg5poKasrisNOExERwrpwLRw1Q+lYzSM8S0IDf
         XBijQXb54RdmR1b2GlSIsbV94e0vD3AFezaqFrXFKxY6sIhmkTvoR+T9zhPG3SNCw+3n
         Dqeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Tk6HLdN1zImWu1L0zmIhWUOzNebvVonDSsfb4q+YHz8=;
        b=jj4Cg0uIIKHMrVXksoKKZP2pUcy+JN7dIBXHKJ2DajmTNoZEpFj7Zrk0Hr0ANwNTeM
         JvTHae3anmb/UQeZJ9DZMLZH4YG9sIfaUbzk9RQZB/mu7nMIpTx3HC2k7wkcm6aGPQWF
         EUqO6LrCrW/aRrRnoBK6LWRT6jVEI1+LSAKQH7ayFq+yluLp60Ecew6txTpTpoB59eAB
         jOqz2xoUHmSDq0PbQShX8P2QH2JQXq7AwihUZaxDzJssUA9dLEMnnbG6RwI6I3tbRnVx
         TZc4XfKApLIUbbgMHXaSkOCcCsjgX9qoVfj4T6g0tE6n8B3CRl4w3ZsYNvclgRyOFVN1
         VZSQ==
X-Gm-Message-State: APjAAAXyYJzsnMqBOfeFNn5T9K0kBIYRRWh0bbA+ExxHVYRdG5ay6E4k
        zovRuGfdWzyV9+0AyJi4Kdw=
X-Google-Smtp-Source: APXvYqw0v/QeeV9dxrpipz3FQeMY4zLHACy6De7ju/2lpJ9r6AFaOZ4/r9kyXbEyz8nARu8XhqxoOQ==
X-Received: by 2002:a17:90a:d156:: with SMTP id t22mr6456665pjw.108.1579278936738;
        Fri, 17 Jan 2020 08:35:36 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:180::ac8c])
        by smtp.gmail.com with ESMTPSA id v4sm29707789pff.174.2020.01.17.08.35.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 17 Jan 2020 08:35:36 -0800 (PST)
Date:   Fri, 17 Jan 2020 08:35:23 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, andrii.nakryiko@gmail.com, kernel-team@fb.com
Subject: Re: [PATCH bpf-next 0/4] Fix few unrelated small bugs and issues
Message-ID: <20200117163520.njanhhs64zy5na6k@ast-mbp.dhcp.thefacebook.com>
References: <20200117060801.1311525-1-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200117060801.1311525-1-andriin@fb.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 16, 2020 at 10:07:57PM -0800, Andrii Nakryiko wrote:
> Fix few unrelated issues, found by static analysis tools (performed against
> libbpf's Github repo). Also fix compilation warning in bpftool polluting
> selftests Makefile output.

Applied first three patches. Thanks
