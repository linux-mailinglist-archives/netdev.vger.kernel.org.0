Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0F104592D8
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 17:17:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238883AbhKVQUn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 11:20:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbhKVQUm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 11:20:42 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 327A2C061574
        for <netdev@vger.kernel.org>; Mon, 22 Nov 2021 08:17:36 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id d5so33754736wrc.1
        for <netdev@vger.kernel.org>; Mon, 22 Nov 2021 08:17:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=q7/1NGwVoTJ7f4vEoIo5LCDfeZBOyXpI5SqV0maaCtU=;
        b=lHoHe6bg2TI3ewKVnQ3eCg5rHcj5JEe+G4j33TWhL3WmKv4vRSBOp0N353+W94m74D
         3gpMEpwCfz6T48a5YdT7hzwVoxWExS5MybqZjCV0VsRPEnukZRyTvDFm1B74asMtGJcp
         DtjnjFvorm1hoNaHw2pjv3Ki4X4q5aqwCT+5dlJB8Rz5wDSEe01Y+4Ft/tsq6QX7wwf2
         DZMAJLAyRFbvuXb4NWUVCM6/v5OHmIZfOzYudisnjUHzniYBzLiCg7NBUpo87UX7fZac
         w2X7JSy/1paU3+f3Pd1AHP2Q11zVZ6TTg4vu04R7qHOXtrtTMjbONJHiywmu0yCtcx9i
         hJ7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=q7/1NGwVoTJ7f4vEoIo5LCDfeZBOyXpI5SqV0maaCtU=;
        b=NxkGrko/2tVrAlHMWi22PksXdiWDH3trY9hcBNr7UuAii924CpBBirxtiijLQQaI8d
         gtKSwyMSboRp0boH9MdkaVRC+LKRoTdhmvETqNmQ1KSXeNMQNy5V2bGRFyKO0jGMrATH
         j07/53zlbfmVael5iil1EfDhqKg0x2wkovzRCiX5VqHisb6tOlV4/OSMFBM8KUF0ob7L
         mUXsiLILt9UR1y9KZyxKJKN+2R2lHSmkW1Dx14jI4p5O9Ot7Mz8MICPU1mKeNQxi5lOi
         t1VqZQ9ayF+7WK0FVz+HnLbdoWkzQVnZ8pYY1Q3TaqLoTF5adRMhiEKTjnTAjsPANiwC
         RNWA==
X-Gm-Message-State: AOAM533ymQYvzey1mcCMhZYjKWRWYwXIlcBDi6YL7bCLLBJnmj4v5tfX
        AuW5X1DUMw4WspuYN3qm3TM=
X-Google-Smtp-Source: ABdhPJwI4UnCoYaUlf7gToYu39CVeymImQ+CtcVQZexA3bZx9rPY8KAF8+q3yxtut0FoV0A1SZI7Ug==
X-Received: by 2002:a05:6000:1c2:: with SMTP id t2mr39963701wrx.378.1637597854818;
        Mon, 22 Nov 2021 08:17:34 -0800 (PST)
Received: from [80.5.213.92] (cpc108963-cmbg20-2-0-cust347.5-4.cable.virginm.net. [80.5.213.92])
        by smtp.gmail.com with ESMTPSA id d15sm12798944wri.50.2021.11.22.08.17.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Nov 2021 08:17:34 -0800 (PST)
Subject: Re: [PATCH] drivers/net/ethernet/sfc/: Simplify code
To:     Alejandro Colomar <alx.manpages@gmail.com>, netdev@vger.kernel.org
Cc:     Martin Habets <habetsm.xilinx@gmail.com>
References: <20211120201425.799946-1-alx.manpages@gmail.com>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <79eee958-818e-9fb4-6b61-4b510d040a64@gmail.com>
Date:   Mon, 22 Nov 2021 16:17:33 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20211120201425.799946-1-alx.manpages@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20/11/2021 20:14, Alejandro Colomar wrote:
> That ternary operator has
> the same exact code in both of the branches.
> 
> Unless there's some hidden magic in the condition,
> there's no reason for it to be,
> and it can be replaced
> by the code in one of the branches.
> 
> That code has been untouched since it was added,
> so there's no information in git about
> why it was written that way.
> 
> Signed-off-by: Alejandro Colomar <alx.manpages@gmail.com>
> Cc: Edward Cree <ecree.xilinx@gmail.com>
> Cc: Martin Habets <habetsm.xilinx@gmail.com>
> Cc: netdev@vger.kernel.org

I guess it's there for type-checking — essentially as an assert that
 field_type == typeof(efx_##source_name.field).  Probably when it was
 added there was no standard way to do this; now we could probably
 use <linux/typecheck.h> or some such.
The comment just above the macro does mention "with type-checking".

-ed
