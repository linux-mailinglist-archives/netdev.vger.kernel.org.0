Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B02581E9323
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 20:40:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729231AbgE3SkI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 14:40:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729044AbgE3SkH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 May 2020 14:40:07 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71CF1C03E969
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 11:40:06 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id x14so7475718wrp.2
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 11:40:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tVbK1Yv/7xTlpE0Uy8ooAV+vrAX7MZIQ0KAnxm2fVpI=;
        b=rA140PRRUooqUQrBNLP+p8JEKHfOWeP+3XTuupR4kJ/e6yv/Mx3eHEEgt8XTncNaW1
         b/OnUjlGSN7OaGwLMMHTeQpMxJuunoapeEkIXtvbSA6BJFFqe5tT3i4v4a6TM6q0pOHW
         FrGuSdxi2jMDxs+Y7UQ3jMhKal2k72Q6v6x7FaNJWhIoL1ypfls6yuFrtkWokYqya9yx
         QEMe6lRvzipoSYY1Q5DV+FKUwPieaSI4oFUYFaaZICqLFaSY+3hAOgUnrHfdq2n4w5RA
         Mv0Hw3JgFm2UYj3vCwBcnl4mH3QijkTBfL2kRW44d2nSsYbBOkFVVUXr83Eb8uevKj9h
         yCJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tVbK1Yv/7xTlpE0Uy8ooAV+vrAX7MZIQ0KAnxm2fVpI=;
        b=Z0uyGl3QVkfBmbb/dW54KZ74bR1R5FU3TRAjoo6FLdIZAxak5ivazuAEdNhDOZ/a33
         OXseZPdKPN1YBy84BDO8iFtKrA8H9cFIrS4ee3Jq7Baj3F7fnRham0KAK7opPI4QrKHc
         bA7FmEZeiIayudfTFkUkQw/G85TJnSDzQ6FDRNkiNyhtfugT8HdFR38Pb1JPKelQbA8w
         1SQeI5wdLMYwtt9YdTBP0Mo7j086E01Jy8sEXHUznGhg7d1VD5oyDjla1WOP5Sji4Wwp
         g2XTI2MsABRsvUOeenbv1LAD2ow2QtE8XOpAC5UmR+2EG4Ct6oM6Kw+B7Kcm6zYk9VH3
         bY6A==
X-Gm-Message-State: AOAM5325Wy/dcSFZu08hovudeh76PBxJdXvZDViezpTQ/QTBzDEOx38Y
        ylZ981/HzUJzSzgBUd2Nm2k2GR2b
X-Google-Smtp-Source: ABdhPJwCsE0maTCY6HO8CytjqhdhZP2wTq8Qr9kbWlOiajp4SwCGkVnHJX9JAs8dfL9vFYuUT+l7WQ==
X-Received: by 2002:adf:df03:: with SMTP id y3mr13697074wrl.376.1590864004871;
        Sat, 30 May 2020 11:40:04 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id h1sm5291134wme.42.2020.05.30.11.40.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 30 May 2020 11:40:04 -0700 (PDT)
Subject: Re: [PATCH net-next] net: dsa: sja1105: suppress -Wmissing-prototypes
 in sja1105_vl.c
To:     Vladimir Oltean <olteanv@gmail.com>, andrew@lunn.ch,
        vivien.didelot@gmail.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org
References: <20200530140322.803136-1-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <0d961904-601a-dd4f-1cf3-088349a6e999@gmail.com>
Date:   Sat, 30 May 2020 11:40:02 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <20200530140322.803136-1-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/30/2020 7:03 AM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Newer C compilers are complaining about the fact that there are no
> function prototypes in sja1105_vl.c for the non-static functions.
> Give them what they want.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
