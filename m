Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3890510EFC4
	for <lists+netdev@lfdr.de>; Mon,  2 Dec 2019 20:05:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728051AbfLBTFM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Dec 2019 14:05:12 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:39618 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727580AbfLBTFL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Dec 2019 14:05:11 -0500
Received: by mail-wm1-f67.google.com with SMTP id s14so636447wmh.4
        for <netdev@vger.kernel.org>; Mon, 02 Dec 2019 11:05:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tanaza-com.20150623.gappssmtp.com; s=20150623;
        h=references:user-agent:from:to:cc:subject:message-id:in-reply-to
         :date:mime-version;
        bh=cpDuQ+8S1NqmWh2GgkrifCfeM8SlTPIIbhI2n6BWOvs=;
        b=sonkycj1mFy8Md475zDtj1AcFk5pt6Lup/DZrpQiH9Mku7PBXg96UbiXN7bNn3Q6gu
         LvdWF/DqMoCYIoLf1KYLQh5fE426TWIrDjM8ItYYFYHzaP0iaRQwRES1ZA3KRxOhGpRP
         UiEYYPcYklySl06jvrC9Y6BhpQM3IX+KEqNUfJwBKTAiuqk2WwL3LBEASEM2tLQnJCjR
         p4Km4TTqKack3gX3zFL5efSJmCQHtO6rHK9fm8ZXmmjsfZ1MBuRrNKPROyjfzs+xBrRF
         WRaOGLWo7r1qu8/CYAKzaY0E6HlX8/1Th6zpmZfxp9zpvBDDlO+gtzu/fhlNiLVFy/Uy
         oRpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :message-id:in-reply-to:date:mime-version;
        bh=cpDuQ+8S1NqmWh2GgkrifCfeM8SlTPIIbhI2n6BWOvs=;
        b=o1cmFyx5DdHGJSr7OG0HcrknS58QpQ0Tg4hAsABFeotGOUp6USOVjOXztEI39eeRRR
         MlySsVgCm1EnnFuYtTz4PY+Gm5PC1uyNqNJZrhHd5FfFRCAcKzzyR66GBbr8CBIzq15v
         HTeuaVDlIaeAgE6qKPJBZGh+Sc2SFASgGEOn1fL3zcToo4l1Lclk3aIPl74VYrJCe+W8
         1kbA1RYW066ukTJRiKlGtGbr8S975hxKJAdc+grDB5hxcd2mDPOQsVo+OLmRG67xCJmG
         GktiricVviE0hW5osexaBpQCQYPUH5CdGOwLSGxRqXfoY4zd0U06NHZOc+cTi1yZTs/j
         kerw==
X-Gm-Message-State: APjAAAV1W1papHy0Xch+edrBF7lOet7n/wIBzX9qaqVHGxHqUnRvX/eN
        eCLXVQxuW6K+zUJhXscj+9FEf3WZdWgntg==
X-Google-Smtp-Source: APXvYqzXJDiESvArk5u/jax/qwNnw5RQ+BTZyzJ0XCZtnxIJWw8vPfN7p/aPNd9ERrjj1W1VOi5jTg==
X-Received: by 2002:a1c:3d87:: with SMTP id k129mr31825358wma.26.1575313509766;
        Mon, 02 Dec 2019 11:05:09 -0800 (PST)
Received: from sancho ([37.162.99.119])
        by smtp.gmail.com with ESMTPSA id c2sm378380wrp.46.2019.12.02.11.04.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Dec 2019 11:05:01 -0800 (PST)
References: <20191202185430.31367-1-marco.oliverio@tanaza.com>
User-agent: mu4e 1.2.0; emacs 26.3
From:   Marco Oliverio <marco.oliverio@tanaza.com>
To:     Marco Oliverio <marco.oliverio@tanaza.com>
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        fw@strlen.de, rocco.folino@tanaza.com
Subject: Re: [PATCH nf] netfilter: nf_queue: enqueue skbs with NULL dst
Message-ID: <87r21mv9aj.fsf@tanaza.com>
In-reply-to: <20191202185430.31367-1-marco.oliverio@tanaza.com>
Date:   Mon, 02 Dec 2019 20:04:37 +0100
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Marco Oliverio writes:

> Bridge packets that are forwarded have skb->dst == NULL and get
> dropped by the check introduced by
> ...

ops. sorry for the multiple emails, made a mess :-)

Refer to this thread.

M
