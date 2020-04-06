Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16DA019F079
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 08:54:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbgDFGxw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 02:53:52 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:37849 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726495AbgDFGxw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 02:53:52 -0400
Received: by mail-wm1-f66.google.com with SMTP id j19so14556881wmi.2
        for <netdev@vger.kernel.org>; Sun, 05 Apr 2020 23:53:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vdHwawrg2goF/xDkxCClW5/26st3fBn8hf31j+8q+80=;
        b=L5a2x2EjfC+MgLzz27jW8wF9vUHG2Wy3ZgiF0nRzmg6Ql350EeqDmebY5efPudaosk
         mxFMPWQriqhYdAVxN76boSa3DCnfq0KXBm5WsZQRifdqQkVjx9rDEf/EolGNJmjhEtEg
         gyzF8LBmLVISgbyaBcat9rNqhm27yXKSqOCxFUl8uRpZYwUwlpFej7HAaFX0dL8IMzSd
         6XPbNbzM8712mnbMXK8+zeSv5MMgooTpl78Ld7EsaVfpA8v7+18xBNI631YYpelUHvB7
         ZZ5YC3m58ULqV0xMw5Db15Szkfc6H9bJnkxx81Ix7+NUZC8sxTx1ckHqtppvb1yPmXoz
         ocxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vdHwawrg2goF/xDkxCClW5/26st3fBn8hf31j+8q+80=;
        b=AuSaFsV3yxHbca7fUgZpdHqAWY2Thba8ntj3+bhZPiTOeYu/CiSZ4yxOqAURMq8nOE
         ssiG9YzGnJSqI5k8DzT3r6OoYDQ98Ig2fmpW6k0LSwJf8AfRfnB3h3FB07wHU4PRn8qR
         gwYCzG93kVYrLwj+7OVPLXWipX8IJ4U7ol+7DjCvD4RRb6W9Q68uO3YWdXRX8zte/7A2
         +dgUG+slWODC8Cpjvil3e0Vgd8NZB13URznF7umMgHN5lmKfsFwnTTZiD/+qWsqo8WMS
         u01kcfuTrZiszgAlIhIpyTBNKejQnX8vndpCPfw32yDZEkeLPA0/tKZ9wsf+LI4uxtbi
         nvfA==
X-Gm-Message-State: AGi0PuburUq2g0Xhke3AB1RrVPEBLZcL21urz6t4HwYEXmukNCuQfnUK
        Ri6PunT4pyuhL6QhwdQTBSZk7g==
X-Google-Smtp-Source: APiQypLGS7pKJ73ev+kPHpiX/tZswkIym+3HYA7yCJNAIDriFH59VDOhOHRwWL/6KQTqY8bi176hnA==
X-Received: by 2002:a7b:c8cc:: with SMTP id f12mr1685011wml.7.1586156030040;
        Sun, 05 Apr 2020 23:53:50 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id f187sm24417209wme.9.2020.04.05.23.53.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Apr 2020 23:53:49 -0700 (PDT)
Date:   Mon, 6 Apr 2020 08:53:48 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com, mlxsw@mellanox.com
Subject: Re: [patch iproute2/net-next 0/8] devlink: spring cleanup
Message-ID: <20200406065348.GA2354@nanopsycho.orion>
References: <20200404161621.3452-1-jiri@resnulli.us>
 <20200405192109.5e883411@hermes.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200405192109.5e883411@hermes.lan>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Apr 06, 2020 at 04:21:09AM CEST, stephen@networkplumber.org wrote:
>On Sat,  4 Apr 2020 18:16:13 +0200
>Jiri Pirko <jiri@resnulli.us> wrote:
>
>> From: Jiri Pirko <jiri@mellanox.com>
>> 
>> This patchset contains couple of small fixes, consistency changes,
>> help and man adjustments.
>> 
>> Jiri Pirko (8):
>>   devlink: remove custom bool command line options parsing
>>   devlink: Fix help and man of "devlink health set" command
>>   devlink: fix encap mode manupulation
>>   devlink: Add alias "counters_enabled" for "counters" option
>>   devlink: rename dpipe_counters_enable struct field to
>>     dpipe_counters_enabled
>>   devlink: Fix help message for dpipe
>>   devlink: remove "dev" object sub help messages
>>   man: add man page for devlink dpipe
>> 
>>  bash-completion/devlink   |   8 +--
>>  devlink/devlink.c         | 131 +++++++++++++++++---------------------
>>  man/man8/devlink-dev.8    |   8 +--
>>  man/man8/devlink-dpipe.8  | 100 +++++++++++++++++++++++++++++
>>  man/man8/devlink-health.8 |  30 +++++----
>>  5 files changed, 181 insertions(+), 96 deletions(-)
>>  create mode 100644 man/man8/devlink-dpipe.8
>> 
>
>Since these all don't depend on new kernel features, let me take
>them directly and skip net-next

Okay.
