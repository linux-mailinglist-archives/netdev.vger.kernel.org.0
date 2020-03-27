Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8B7B19621C
	for <lists+netdev@lfdr.de>; Sat, 28 Mar 2020 00:42:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727096AbgC0XmT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 19:42:19 -0400
Received: from mail-il1-f179.google.com ([209.85.166.179]:45692 "EHLO
        mail-il1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726134AbgC0XmT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 19:42:19 -0400
Received: by mail-il1-f179.google.com with SMTP id x16so10409714ilp.12
        for <netdev@vger.kernel.org>; Fri, 27 Mar 2020 16:42:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=gQnNUoa9zwJYUw5zj561pfJl++D5glDXdtIuKEZH7Mw=;
        b=oOpnZv/a+HE44jVQ5eimZOxUStuEqEgSXd2QVqGqk2tAl+txkM/PMcLfKcbhhYWAoZ
         uT/riZb+j6voaRu1AOGsM2HA24m8Pb+x6T5HO8iu83uVrDH1Tg85rBzqwoFLYTWo0P8l
         NTp94qfkrmBbs/7Vxa2UtqKT0iuodb3Dn4RsYaT/BkbZ7/Jra1h0lZZ+nVc8ZW71D9RJ
         IRIA6TR91ONWoGZbm0S5LMvJx6/OPipVREY9/bLvJuUTUYjN92yhXKzzQxQChdL/8AkB
         br8LVvHZJGzN/ZULyP0UkNBEamdGB7xYQX57OFbQhI2bX05qCqJMv79KjnUSGCp4KdHH
         KzCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=gQnNUoa9zwJYUw5zj561pfJl++D5glDXdtIuKEZH7Mw=;
        b=WMpLQDAl/eQXhkOyI8/yVZskLWkB3Jfgqe127dF3xBbnMfFjehFGNe9h8vKHPBYOQY
         6XK+kwsakdU5k4XE9ia5JdNP+Db6ZdnN5Cxm2YPRecES0a5hPkyf2B1LJYbwJ327t/5C
         rzsY87+5ka1B3eIQ2RxmKAhR0/Zlo5G+UG6cuCyrnJDD2v7xVZqjnq8L1LaWrMjl9UmN
         OE2FfjGlcxwJ4qGqUGIN7ivhkppn/wA3yykcVFqLDmBGH8r8Nl5b1zpCD+BLGwSlYpbS
         FMFxDSejNyVw8syyrp1GbnWwkG8pjarXRbeIrgQmChXmex3MTlajUjtQxUwhfyqrwhfJ
         Tohw==
X-Gm-Message-State: ANhLgQ2HQMMARkMHyAyfKZ0Q9CPTL1ODlW7Ad23SZgJGZh0sZ1/NxTs8
        fxugIyT95F+6pvVxX8lz64ccg8auifgIeg==
X-Google-Smtp-Source: ADFU+vv29dL3Fsgs1zqLtcrZooLn2UYUjnU6gAZRlCzTdwyaWErGM5BnOF59fJmMQ5xSJWu2K27lOg==
X-Received: by 2002:a92:d28a:: with SMTP id p10mr1480338ilp.191.1585352537839;
        Fri, 27 Mar 2020 16:42:17 -0700 (PDT)
Received: from [172.22.22.26] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id n5sm1916793iop.23.2020.03.27.16.42.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Mar 2020 16:42:16 -0700 (PDT)
To:     David Miller <davem@davemloft.net>
Cc:     Networking <netdev@vger.kernel.org>
From:   Alex Elder <elder@linaro.org>
Subject: IPA Driver Maintenance
Message-ID: <cd3cefcd-1b80-d788-38c0-7d2a03fb6a0d@linaro.org>
Date:   Fri, 27 Mar 2020 18:42:13 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I'd like to know what your preferences and expectations are for
me maintaining the IPA driver.

I will review all IPA-related patches and will clearly indicate
whether I find them acceptable (i.e., Reviewed-by, Signed-off-by,
or Acked-by... or not).

Do you want me to set up a tree and send you pull requests?
Should I be watching the netdev patchwork queue?  Or something
else?

Thanks.

					-Alex

