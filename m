Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E254DB2476
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 19:02:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730951AbfIMRCD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 13:02:03 -0400
Received: from mail-pg1-f172.google.com ([209.85.215.172]:43673 "EHLO
        mail-pg1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725777AbfIMRCD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Sep 2019 13:02:03 -0400
Received: by mail-pg1-f172.google.com with SMTP id u72so15540379pgb.10
        for <netdev@vger.kernel.org>; Fri, 13 Sep 2019 10:02:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5tb54EOQZGguzv0ITwwi3McohrFW0dBLJf2I0xbQMcs=;
        b=aa8uruEYnw+hRuJV0ZWOuOpubXApG7+gYHl64uV/bMIKwT3Pe/K8jyiFhMvSJBopP+
         2iIAKfi2NiMUEByeSklVxDwQhG5UGUxPjWxX50M3rPCsvJou57qi0bfwmoqjs7OuxgBj
         RRieipozccxgBj+X96vGTRBOoD0IREUjkCotrngr95Q2ZA+IrW5OQEwm1WluNPohOAln
         T1gbV0Zh+8UB7vAKVXs572q8Ftp9UGkXg9unSW9zZ2Tts67Zgw2u1bwu0xt+ueh0Y2oO
         plo76vTVQDuApyeCkLIDk7x7hob95Y7dw4KrBkY2YhQfZb4QUU+gjDo2S1tHRsw8DiBk
         qiNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5tb54EOQZGguzv0ITwwi3McohrFW0dBLJf2I0xbQMcs=;
        b=EvUtsiBSTRMaEtgKmx0KXtmeYn/upODN38ULS6GTJGoclmnMMZG/oxfHKC45UvpVZ4
         zPz4PGl7iqTu1fyP8rSslcAPcaDNjvReSGcjzZymTdGEK/kW35UQgLwExiGfTj+hBGOz
         9iQxGxHfLvUd9iibcWW69qRhIPa6RZxJZHQb6zWKCTqu2JlYROyV6ufxYfdC7lrc30KZ
         4hLL3UlEg8krgkehxI2Z5QHnHZtxjZXIn85AUCJPl6OWr8dVhPTZDWlZw5RUxDh3a5sU
         cQmLrg/msN21KzGHAIN4c54hTP4vAeh+FbSh3jHSkvANst4ANwNKn/d50la3O0AfPVEB
         WBmQ==
X-Gm-Message-State: APjAAAW589DGspDlNL4ZxV9VJwpNel6FDprNGsDsWaLYzAhdOuYplrBs
        YotIBc6XL9OhU89jdC+S9N2oUbkS
X-Google-Smtp-Source: APXvYqyBI5h0/JhCUlWftgqmdz8r/DONuO7DnoAnNDnHVy6B3TjzJipMiyKfWQzv3pKNa3MMcsL4EQ==
X-Received: by 2002:a17:90a:c217:: with SMTP id e23mr6387648pjt.129.1568394122574;
        Fri, 13 Sep 2019 10:02:02 -0700 (PDT)
Received: from dahern-DO-MB.local ([2601:282:800:fd80:f0f8:327c:ea9:5985])
        by smtp.googlemail.com with ESMTPSA id v12sm25029661pgr.86.2019.09.13.10.02.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 13 Sep 2019 10:02:01 -0700 (PDT)
Subject: Re: "[RFC PATCH net-next 2/2] Reduce localhost to 127.0.0.0/16"
To:     Dave Taht <dave.taht@gmail.com>,
        Mark Smith <markzzzsmith@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>
References: <CAO42Z2xH_R1YQBhpyFVziPnHzWwzNV61VqrVT0yMcdEoTd6ZNQ@mail.gmail.com>
 <CAA93jw4SC2choBKXvaTD_5j93Op=RZ9ZEeKmyAu31ys_uNhSyA@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <9d2898f5-e5dc-a2ff-168d-22c69cca5f01@gmail.com>
Date:   Fri, 13 Sep 2019 11:01:59 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <CAA93jw4SC2choBKXvaTD_5j93Op=RZ9ZEeKmyAu31ys_uNhSyA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/13/19 10:14 AM, Dave Taht wrote:
> it came out that cumulus and a few others were possibly using high
> values of 127.x for switch chassis addressing, but we haven't got any
> documentation on how that works yet.

Not Cumulus.

I noted I am aware of 2 products from my history that use 127.x
addresses for communications within a box - e.g., to a bmc - that your
patch could break. Really it was meant as a data point that there are
released products that would be affected.
