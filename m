Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6033E83A30
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 22:16:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726677AbfHFUQ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 16:16:57 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:39434 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725881AbfHFUQ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 16:16:57 -0400
Received: by mail-pg1-f193.google.com with SMTP id u17so42174216pgi.6
        for <netdev@vger.kernel.org>; Tue, 06 Aug 2019 13:16:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=8t1aE3H/SY244+07uuUaKNHaoVM5JxI3EnUyf8XsIKc=;
        b=cFPTjCfS8LPEHdeW4CdOu7UiYP6P0/MQQ3WE8RjRfOzHXvJxoRcqHTsiXAhgxiiJWw
         bMwt+huS1WdMknjwczKNdA96D5dhMtNLpVravAMUzuhic2sW086AFk4f4iUSnl5PS92e
         Nvc7dyl1MB0WSGI5mrntv0Aop7m92Y58P2ViQtcROSALCxsi/lkzt1fBTDZlZW1Usv+8
         CdO8Ml3MGCpgfzvWF423+zW9n0KnpokHb6W6fIgVDLFWvNqd5eoLDACoekGrkVVdNE/f
         yun6lj6xjXw8c8m4WVmMqXEtqord1j0Sf9Hmtsh4jjLhhjse0p7xk2UtcT7DCsQq5YB4
         gv2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=8t1aE3H/SY244+07uuUaKNHaoVM5JxI3EnUyf8XsIKc=;
        b=Pug5YpVbQei/JDNErPELUbX462InwuugTI9D2iB9jS9O+e6WlH2VStp+IjJG/XWdiA
         wDgKWWR4sdyLnJVGTz0LRBxD4ps4GaPN+3xPI7kJZL+GOQKmaJePHIfC0DJxaSPSah/c
         35OTC+0lE3NI+MuMiwQhDcVtRTBlJxzzJ+lum6XBfV6fupOAopxlWuZf4GWpqhn2uw18
         Nih64/feXNeQdPQINtgaU9tZDJMm7AoMyeySkENM0pr9GxrFrm/Xj4Ummk8ct12xdfgO
         IJLh4geTiProrYweTcXoQnuKsTEgNdP5pFgU3AUHeTHmotVvfoKEBQYqy7z3BmT29ZKq
         gyTQ==
X-Gm-Message-State: APjAAAWQ3XInGEOca2sLKcAAWOmDyAumW4ft/V1xM3WFhgdFbovFNCye
        ucvI2Fs595cuCop/tBH7bag=
X-Google-Smtp-Source: APXvYqzXTcyDygRN8AtDIiaMwj0mlb8y0mnUkXP7ni2yxcIMyFLLspxpgL1JnsZmhhbKDOsECtC8sQ==
X-Received: by 2002:a17:90a:e38f:: with SMTP id b15mr5020415pjz.85.1565122616565;
        Tue, 06 Aug 2019 13:16:56 -0700 (PDT)
Received: from [172.20.55.43] ([2620:10d:c090:200::3:37dc])
        by smtp.gmail.com with ESMTPSA id j15sm120076094pfn.150.2019.08.06.13.16.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 06 Aug 2019 13:16:55 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Saeed Mahameed" <saeedm@mellanox.com>
Cc:     kernel-team@fb.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] mlx5: use correct counter
Date:   Tue, 06 Aug 2019 13:16:54 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <A5535374-57E3-49A5-859D-2779B95B1BFD@gmail.com>
In-Reply-To: <128f1f62141faee7620fbe56202f35ec8f6b42b6.camel@mellanox.com>
References: <20190806182819.788750-1-jonathan.lemon@gmail.com>
 <128f1f62141faee7620fbe56202f35ec8f6b42b6.camel@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6 Aug 2019, at 12:03, Saeed Mahameed wrote:

> On Tue, 2019-08-06 at 11:28 -0700, Jonathan Lemon wrote:
>> mlx5e_grp_q_update_stats seems to be using the wrong counter
>> for if_down_packets.
>>
>> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
>> ---
>>  drivers/net/ethernet/mellanox/mlx5/core/en_stats.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
>> b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
>> index 6eee3c7d4b06..1d16e03a987d 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
>> @@ -363,7 +363,7 @@ static void mlx5e_grp_q_update_stats(struct
>> mlx5e_priv *priv)
>>  	    !mlx5_core_query_q_counter(priv->mdev, priv-
>>> drop_rq_q_counter, 0,
>>  				       out, sizeof(out)))
>>  		qcnt->rx_if_down_packets =
>> MLX5_GET(query_q_counter_out, out,
>> -						    out_of_buffer);
>> +						    rx_if_down_packets)
>> ;
>
> Hi Jonathan,
>
> This patch in not applicable (won't compile and there is no issue with
> current code).
>
> Although it is confusing but the code is correct as is.
>
> 1) your patch won't compile since there is no rx_if_down_packets field
> in query_q_counter_out hw definition struct: please check
> include/linux/mlx5/mlx5_ifc.h
> mlx5_ifc_query_q_counter_out_bits
> 2) the code works as is since when interface is down and port is up,
> technically from hw perspective there is "no buffer available" so the
> out_of_buffer counter of the drop_rq_q_counter will count packets
> dropped due to interface down..

Hmm, confusing, but okay.  I'll send mail on an issue we're having
separately.
-- 
Jonathan
