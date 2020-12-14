Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FD132D9BAB
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 17:03:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439392AbgLNQCs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 11:02:48 -0500
Received: from mail-ej1-f68.google.com ([209.85.218.68]:34600 "EHLO
        mail-ej1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728209AbgLNQCq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 11:02:46 -0500
Received: by mail-ej1-f68.google.com with SMTP id g20so23240417ejb.1;
        Mon, 14 Dec 2020 08:02:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QjL4adJZs0AMrAVUGFkpZofpmty3/E0ZmCXzxBFdS9g=;
        b=OQQLOqsvWvaQdIIlsp3qieMc+kNodan9+FlRFcYMixgxLuwlOKgyVpf0s4CuK21zwx
         XTtODxnkXhNtd1v57Ah7Q1WpVvbVLlymhd64DyyY2cXVifj/Q7n7EG0c0weMjUlzezUX
         3J7OQflO+mRVM2pI13FEdCemMQ1mFaSqXzBDkKDRudo+bG8aqgDNVBrnozM1gsd6Knzw
         2Jqjww9YruEeA7uOTdrtZg19SwXhYx1ZvdPzzyq11HCR/g5wvb//R5zdKQg/4mW5qeHU
         d46/epqWvFT+ZPYSSJ15aJqRwawyOfvs6hdbNHNJeo1uvW9rvfbCLgaltDNqgNjlPw39
         uxdw==
X-Gm-Message-State: AOAM532yfCBFqDOnCiefb8gpu2/nhexGvzf1j8b6eM9wO6nkaVlk6iJA
        KH7bXp0wXPU+9cwsZ721EngdQ+BrQFQ=
X-Google-Smtp-Source: ABdhPJxgm18FCHtI7zbS+tHOST8IHEw9MAaGTjBilw+edq/rstPkLCaEEIN/uqe33+uqdKnICVG9Bg==
X-Received: by 2002:a17:906:b096:: with SMTP id x22mr1836794ejy.471.1607961725125;
        Mon, 14 Dec 2020 08:02:05 -0800 (PST)
Received: from kozik-lap (adsl-84-226-167-205.adslplus.ch. [84.226.167.205])
        by smtp.googlemail.com with ESMTPSA id zn5sm14034216ejb.111.2020.12.14.08.02.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Dec 2020 08:02:03 -0800 (PST)
Date:   Mon, 14 Dec 2020 17:02:02 +0100
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Bongsu Jeon <bongsu.jeon2@gmail.com>
Cc:     linux-nfc@lists.01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Bongsu Jeon <bongsu.jeon@samsung.com>
Subject: Re: [PATCH net-next] nfc: s3fwrn5: Remove unused nci prop commands
Message-ID: <20201214160202.GD2493@kozik-lap>
References: <20201214114658.27771-1-bongsu.jeon@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201214114658.27771-1-bongsu.jeon@samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 14, 2020 at 08:46:58PM +0900, Bongsu Jeon wrote:
> From: Bongsu Jeon <bongsu.jeon@samsung.com>
> 
> remove the unused nci prop commands that samsung driver doesn't use.

Don't send patches one-by-one, but group them in a patchset.

Previous comments apply here as well - NCI is acronym, start with
capital letter.

Best regards,
Krzysztof

