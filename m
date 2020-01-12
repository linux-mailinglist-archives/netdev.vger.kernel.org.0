Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38D07138464
	for <lists+netdev@lfdr.de>; Sun, 12 Jan 2020 02:07:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731849AbgALBHA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jan 2020 20:07:00 -0500
Received: from mail-il1-f181.google.com ([209.85.166.181]:43627 "EHLO
        mail-il1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731841AbgALBHA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jan 2020 20:07:00 -0500
Received: by mail-il1-f181.google.com with SMTP id v69so4924761ili.10;
        Sat, 11 Jan 2020 17:06:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=oDI+n2k3ddmMpnEGOLZkg6TpTxZKeSdp9ompHX+NuMQ=;
        b=Ap9WEeR1Ad3HNaj2YTso4GRuvpMSLzLowA1435rIOZn461Y+SsK4/HlMCnwmXYEYNT
         Ci2Earg0JOCVYYPvuENQk/uYt8wCN+SiDXG87rA6kOCmXjI6vzgt42qks8EGWUwmiUBp
         7tLox7hkViQ8MsawG/GPMv9RLhWcqIEdRV47d+uGtBEPVZzIlGxhRfvejyi16lYQz5s2
         2CG9XN+jr2KRfzELpRrdC+AJq9St2pLfYKlrAXW+oExr3zMgzvGhlgeXG9nVUVQnh8dk
         TPjkp3iIpHavTwTw9rDjGENMbEA4WU/SvdpD4yZKtbNF86wm7bFM9cd/1rTpdBF2V8jc
         Ew2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=oDI+n2k3ddmMpnEGOLZkg6TpTxZKeSdp9ompHX+NuMQ=;
        b=qtEdyEXycMwiOyRjJ0IFxNO8jpzo0K7x29VM/YnOUWegPx+/+GBOdkfr4vOkglNK2r
         Z6Wg9spgXASab21Iq7lxzvKjTHwNISZ4qdMv+ehf7OU/WK19O+mfvOBeH+oL4/a8ZYmk
         JggmwEwW6bJm7Y/AApnhAJups7/IGmvVyIdu43qIMxQktLcKAAmnK2FWg6goJaljfV9E
         dSdRE5p8I6GPaV5yxbrGuPsR8zDUxRnhoAoO1r2X429gutg/HT20OPj3M6ccx2NU9Ncu
         QvR0BwFizva41pYFMJLpSZH5F+itOeaXeXbDYckhY0ARFGtiwacs6ep6QpCneZ3fUZle
         9VIg==
X-Gm-Message-State: APjAAAX5z6agMSHW5yVeEJmK+SEF/dViM+hKD6t/v9Mw44/ITvcX4Svy
        N8CAKTMwlELsc8KpNGI/QDI=
X-Google-Smtp-Source: APXvYqyYs8yvijIc8eaP0PAJ/6Yg9QoGkznEkH4KBjTGTN7ihqxYVp9p4xePTmwkKqROBWSGaelwew==
X-Received: by 2002:a92:d5c3:: with SMTP id d3mr9156718ilq.250.1578791219376;
        Sat, 11 Jan 2020 17:06:59 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id f189sm1633156ioa.10.2020.01.11.17.06.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jan 2020 17:06:58 -0800 (PST)
Date:   Sat, 11 Jan 2020 17:06:52 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Eric Dumazet <edumazet@google.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Martin KaFai Lau <kafai@fb.com>
Message-ID: <5e1a712c16d1_76782ace374ba5c02b@john-XPS-13-9370.notmuch>
In-Reply-To: <20200110105027.257877-12-jakub@cloudflare.com>
References: <20200110105027.257877-1-jakub@cloudflare.com>
 <20200110105027.257877-12-jakub@cloudflare.com>
Subject: RE: [PATCH bpf-next v2 11/11] selftests/bpf: Tests for SOCKMAP
 holding listening sockets
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Sitnicki wrote:
> Now that SOCKMAP can store listening sockets, user-space and BPF API is
> open to a new set of potential pitfalls. Exercise the map operations (with
> extra attention to code paths susceptible to races between map ops and
> socket cloning), and BPF helpers that work with SOCKMAP to gain confidence
> that all works as expected.
> 
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---

[...]

> +static void test_sockmap_insert_listening(int family, int sotype, int mapfd)
> +{
> +	u64 value;
> +	u32 key;
> +	int s;
> +
> +	s = listen_loopback(family, sotype);
> +	if (s < 0)
> +		return;

Will the test be marked OK if listen fails here? Should we mark it skipped or
maybe even failed? Just concerned it may be passing even if the update doesn't
actually happen.

> +
> +	key = 0;
> +	value = s;
> +	xbpf_map_update_elem(mapfd, &key, &value, BPF_NOEXIST);
> +	xclose(s);
> +}

Thanks,
John
