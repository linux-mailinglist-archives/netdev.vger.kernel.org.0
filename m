Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 467C54A58D3
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 09:55:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234082AbiBAIzf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 03:55:35 -0500
Received: from mail-vk1-f176.google.com ([209.85.221.176]:46948 "EHLO
        mail-vk1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231912AbiBAIzf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 03:55:35 -0500
Received: by mail-vk1-f176.google.com with SMTP id z15so9947969vkp.13;
        Tue, 01 Feb 2022 00:55:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2RuOMLMz4bnyUYfxcxLnbEyL44qsRLFQ8j/HdFTX00k=;
        b=yhi+8Fq42rcsY9O4l/VYgaP6N9KiIkHQjvkpy31kKNEh/rkA5r+GVIdr7tI9OQTtiM
         beqsQQtKJec+q3a8mDriQwy6G3+OOlxX+Unqxcbxatl3K84tO4AT3/AZFCrVfWVp1tc5
         sd3ByeNnplfEk/9CthyRJxl2Fta0hLGyaGOhbWSRWsS948CKYL4uqyDdw5XnlRsdEh3V
         Iovr+9Z59b38r+MQbnkniMeNqGHqCudPHB8QVlM8QeUkBVifGl0ZspQmWapNRMm71v1e
         gl5Vv/gD6w7idgItJztsnQKWGOAnMfQY0CXJyW1IgUb5YgpFo5kN6ltsDpGwZ5E+4Ulx
         o5Jw==
X-Gm-Message-State: AOAM533EY0Dd0koG4cGjhjsi3F8xQAq0yErUV9CBPD6r0eHV5MLbZnUe
        AbW3kvnGZzT+7QJxDjOtr/itE5E9RuO66g==
X-Google-Smtp-Source: ABdhPJzYVjNJ4MsTE7ES+lFfzk1fLUD4hjg5f/4A6SYOdCiqthKWu5peXHX/a5g6JFrxMzvCF5HLpg==
X-Received: by 2002:a05:6122:792:: with SMTP id k18mr9587633vkr.15.1643705734263;
        Tue, 01 Feb 2022 00:55:34 -0800 (PST)
Received: from mail-ua1-f46.google.com (mail-ua1-f46.google.com. [209.85.222.46])
        by smtp.gmail.com with ESMTPSA id w6sm3858481uap.12.2022.02.01.00.55.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Feb 2022 00:55:33 -0800 (PST)
Received: by mail-ua1-f46.google.com with SMTP id w21so13418015uan.7;
        Tue, 01 Feb 2022 00:55:33 -0800 (PST)
X-Received: by 2002:ab0:44c:: with SMTP id 70mr10103974uav.78.1643705733378;
 Tue, 01 Feb 2022 00:55:33 -0800 (PST)
MIME-Version: 1.0
References: <20220129115517.11891-1-s.shtylyov@omp.ru> <20220129115517.11891-2-s.shtylyov@omp.ru>
In-Reply-To: <20220129115517.11891-2-s.shtylyov@omp.ru>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 1 Feb 2022 09:55:22 +0100
X-Gmail-Original-Message-ID: <CAMuHMdWfCjb+ZzTFLw1a8g2o5oGfLG_qTr702eq7z0bE0f3Yjw@mail.gmail.com>
Message-ID: <CAMuHMdWfCjb+ZzTFLw1a8g2o5oGfLG_qTr702eq7z0bE0f3Yjw@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] ravb: ravb_close() always returns 0
To:     Sergey Shtylyov <s.shtylyov@omp.ru>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 1, 2022 at 3:00 AM Sergey Shtylyov <s.shtylyov@omp.ru> wrote:
> ravb_close() always returns 0, hence the check in ravb_wol_restore() is
> pointless (however, we cannot change the prototype of ravb_close() as it
> implements the driver's ndo_stop() method).
>
> Found by Linux Verification Center (linuxtesting.org) with the SVACE static
> analysis tool.
>
> Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
