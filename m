Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E45817C1EF
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 16:36:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727060AbgCFPg0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 10:36:26 -0500
Received: from mail-pf1-f179.google.com ([209.85.210.179]:37165 "EHLO
        mail-pf1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726485AbgCFPgZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Mar 2020 10:36:25 -0500
Received: by mail-pf1-f179.google.com with SMTP id p14so1287317pfn.4;
        Fri, 06 Mar 2020 07:36:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=C+EB+uuuB8S9ihmZbiESaEvd2Xd6xGCpZoaRWBSkWAU=;
        b=iTfMsjvcuEAoDy0MM2MSyIdI3zSNAGNkEr0JqC4aacbRChOMKupNENNMpP4qczbepR
         Z7fyFTG0ijnE71vR/cZBes9Pdp6yJKzGR6gg9oDgDiG0mgHEP8bjr10MCLdOIHRBfjux
         UGiKD2iSGzvSr28P1FAKfs/LhOnIh2uvu61w9OcFL5n8SEnjqtfXqo+QADTtJwfYuzGN
         ecZ3QYMFTu2NXWsmFEZxNuvmRGj8DUJYllIIXpVfDmf+3RkhQ1HMGsxsBkXTOItxH7P+
         VV9DnGr9y/++3FMrwF7zAsIBhNXx3gIQmOooCc9fFYTyAedETKHCf00PBZq7lkrr92l+
         TouQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=C+EB+uuuB8S9ihmZbiESaEvd2Xd6xGCpZoaRWBSkWAU=;
        b=aYI22gJpGUPlYUvhFMRNsve433bUS336+eQHRnhWcBwCsBmM9dJMAm3w4jUn5YjoMm
         17oSZCGP+lJfxD+szN7Jes4eidKMuqXkt0pmJ75ZPbtZsCOq3+oSuRsxTglRGRlvBDO0
         E1EE7yZos3uYfXlL3lHft2d31ydk0FTJ7iQFd5H+fKZ3VH7tqvnIuolb4UYdccap9GZ2
         99fSJV+a1AyTBtxNcvCFNIwh14aIGoSIVtyAdCzZscS5zdrJ0LcEP9QeSq+U45wWaT13
         5rR7zRmXinB3R8VmXBPhozqjAz8gCaI8aSxGE8z5J+ifwiCoZ2rg/7+/KtQGxSFkAOfb
         aBkQ==
X-Gm-Message-State: ANhLgQ1sawAqh/1fHrb9i1awPlkTX5Qnze739fZctuMu3FcqXznX4jP2
        ZHH1Cd1GbJsWJU7DSOZ4OAg=
X-Google-Smtp-Source: ADFU+vs2ZGlXc0iCCeCpSyvA+FqOK7+Z1rBLZetlzFY4c2/8EfdopbHkVvCVcLy4aSUOjmqr3a20mg==
X-Received: by 2002:a62:c5c6:: with SMTP id j189mr4227274pfg.159.1583508984604;
        Fri, 06 Mar 2020 07:36:24 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id b9sm6843235pgi.75.2020.03.06.07.36.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Mar 2020 07:36:23 -0800 (PST)
Date:   Fri, 06 Mar 2020 07:36:16 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Lorenz Bauer <lmb@cloudflare.com>, john.fastabend@gmail.com,
        Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     kernel-team@cloudflare.com, Lorenz Bauer <lmb@cloudflare.com>,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <5e626df05abb4_17502acca07205b47e@john-XPS-13-9370.notmuch>
In-Reply-To: <20200304101318.5225-10-lmb@cloudflare.com>
References: <20200304101318.5225-1-lmb@cloudflare.com>
 <20200304101318.5225-10-lmb@cloudflare.com>
Subject: RE: [PATCH bpf-next v3 09/12] selftests: bpf: don't listen() on UDP
 sockets
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenz Bauer wrote:
> Most tests for TCP sockmap can be adapted to UDP sockmap if the
> listen call is skipped. Rename listen_loopback, etc. to socket_loopback
> and skip listen() for SOCK_DGRAM.
> 
> Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> ---

Acked-by: John Fastabend <john.fastabend@gmail.com>
