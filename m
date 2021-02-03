Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4508F30D326
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 06:41:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231377AbhBCFlN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 00:41:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229995AbhBCFlK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 00:41:10 -0500
Received: from mail-qv1-xf33.google.com (mail-qv1-xf33.google.com [IPv6:2607:f8b0:4864:20::f33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A301C06174A
        for <netdev@vger.kernel.org>; Tue,  2 Feb 2021 21:40:30 -0800 (PST)
Received: by mail-qv1-xf33.google.com with SMTP id es14so11144481qvb.3
        for <netdev@vger.kernel.org>; Tue, 02 Feb 2021 21:40:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=DOR+5GEacFMqHN+1IBwunsE0iiaRjaaxFk+4cnTED34=;
        b=q6pBDsWc04vg/qRFIFtlcYcud9n0BxzTurvPR2DMkYu7OwcbS96d1kdIq7/DTMRwv9
         9ChyU4WVIs7SKiQHJVWPDROpMezLC7UOroQz4t7fl/cXLTwYxq8bsxymRI70kFBOOCqO
         Ky11TOVslL6gw7Gy2svD0zwsPT91e5kqUWNxE0Iw9ggfF9lgjSCNvueYBdIYkvF2z0Gh
         MgsR3bOMtHE65isU77m1UqnqYy3EZp+MMzccXiaQf3e9rzhwnPMHmXQw0bqofL2RnnrS
         7HlopoEsw4wbCa5n4P3z9JgqBPgk9VY6GAGr9O9elUEHGUFtMu6rKOdExNsdqz/21x89
         4fRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=DOR+5GEacFMqHN+1IBwunsE0iiaRjaaxFk+4cnTED34=;
        b=FnUUa1TkGBRf2Cw7DR4PrRMbXJ1oYWDzaQO5vkdNsVnUNeFAlhzi8vjJH2hD4uMjNO
         BHdTZSR+6UtBN6m7WEnQvLElkTrWgDgRaEWfausom6Ws9t8TyZ8Nb8XEHHUzhkmWnPzQ
         Thgy04Uya9ivCQ4O9/R4SezPzmb0Ry8yFONNbhGZQM+nWhmNskNFnjLvAf/6TbKOA8eB
         3sr6pbNyUA+3LdRuCCnNJ9aloWqI0FPWptQuuYJi87mVpUwtoAcuNNV41i+0Z+r8CWfc
         1aY7jkEUd1GfECTgxxJVYypvJI0okjDZUI+aQfKPg7WRlMSdO2yAXslVaNdIPpjiACX1
         5hvg==
X-Gm-Message-State: AOAM533QAXliCY+qsI4n5md0jpmbLkGjf8cUNkmbLhjqUnf76O7My75G
        3yHIXWZszWk3k/K2d5/HQagT26y1pstKkw==
X-Google-Smtp-Source: ABdhPJwzKsXSdaFa752weDCQnY/D08NROpTAmXMQ2l2sc8h+JQyyNnoH9bZp8Htn7Tvc/EowIS7XMg==
X-Received: by 2002:ad4:4b2c:: with SMTP id s12mr1425891qvw.21.1612330829357;
        Tue, 02 Feb 2021 21:40:29 -0800 (PST)
Received: from [192.168.2.7] (c-67-182-242-199.hsd1.ut.comcast.net. [67.182.242.199])
        by smtp.gmail.com with ESMTPSA id h6sm903475qkf.96.2021.02.02.21.40.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Feb 2021 21:40:28 -0800 (PST)
Subject: Re: [PATCH] Add documentation of ss filter to man page
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org
References: <20210128081018.9394-1-astrothayne@gmail.com>
 <20210202142508.3d0aca91@hermes.local>
From:   Thayne McCombs <astrothayne@gmail.com>
Message-ID: <b19b6122-7b44-533c-98e9-fcd408d7ede3@gmail.com>
Date:   Tue, 2 Feb 2021 22:40:26 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210202142508.3d0aca91@hermes.local>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Awesome! Thank you very much! Sorry about the spelling errors.

