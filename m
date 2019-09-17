Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D8B9B534C
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 18:46:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729506AbfIQQqf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Sep 2019 12:46:35 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:33379 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725847AbfIQQqf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Sep 2019 12:46:35 -0400
Received: by mail-pg1-f196.google.com with SMTP id n190so2336379pgn.0
        for <netdev@vger.kernel.org>; Tue, 17 Sep 2019 09:46:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XmEDVfnPZ7Sw0RlJrwyJ1pnBVmjpwPxNFh9MEavYqXY=;
        b=cmhhUs856V3a6keV5jDCX9Fvp8r8hLOt0Z5paN+eogCOpoiMEktYCdoJbrw0m8PAu8
         pI6+VKdj2O2Yanc8u//Wf8gJNoqUFNlXazwpolbiO6ZjzYvKk4iDq3aqZ0OZNmLEFg/s
         T6VsPKq66n5LFFPx0tiCULoisu6zF2O88guZESca6atmTBbTBE4vYZHrICkByNNFQgIw
         w4ZLWgWhmsGU1fKaJT8oFF+WXG9XTR69l7qaIWXC/CfAlc+zrJXg5A7pPELzaumMF9qJ
         Ny7O8Bp514rinEOo6x5gyTx4sanfmQ28zoJlPryx2vmhgMAwD7Yp2riqots4flay1RiJ
         lZLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XmEDVfnPZ7Sw0RlJrwyJ1pnBVmjpwPxNFh9MEavYqXY=;
        b=bFq0hh7IC5UlLQ2PcFz1UQs4g7J5sgbrJZLfTIqDBz9SbLDdJluoqWnI7to1JK9+xb
         BqbAPPd5m6jivOZ7C9mcFWlcqQlKpYNMlD2+iL9fm4OamS9i0GH+sHNFaypc0VM2sL8k
         6MT4Dy49DG6zZ2QYeb1KTaVAHl3VzDG+eClQ7Z0jjz6vcReKtrNr3HLn2MS7Fqi8g5wF
         tBuleYfdZht77M+d11g5F8TDlwUHMzYi5YLmVhNazvuciP8Cd/2iGX7eVR2aEHeieSek
         Zq9n9OkvvrIBLAgb6J69FNLnY/unF+d7OCRt65dAFNk/IJrSlwUteoxaglCHLKJUam49
         QlcA==
X-Gm-Message-State: APjAAAVEyV6sQS8MfN2sj9FNC+qX4dXZBX6WN7MpqlavjF90FTK4j5EM
        mpYP+8wyN0NvTJtv0Tm+6go=
X-Google-Smtp-Source: APXvYqzEGjYBsphTLatZmiYclmCz+xkW1Ni0YA8vKyYlvkjT7A+uGfew6FsEh9fSMklwtRVFMYq8cg==
X-Received: by 2002:a63:d643:: with SMTP id d3mr4106529pgj.249.1568738794357;
        Tue, 17 Sep 2019 09:46:34 -0700 (PDT)
Received: from [172.27.227.235] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id w5sm2736701pfn.96.2019.09.17.09.46.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 17 Sep 2019 09:46:33 -0700 (PDT)
Subject: Re: [patch iproute2-next v2] devlink: add reload failed indication
To:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, idosch@mellanox.com,
        jakub.kicinski@netronome.com, tariqt@mellanox.com,
        mlxsw@mellanox.com
References: <20190916094448.26072-1-jiri@resnulli.us>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <c9b57141-2caf-71c6-7590-a4783796e037@gmail.com>
Date:   Tue, 17 Sep 2019 10:46:31 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190916094448.26072-1-jiri@resnulli.us>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/16/19 3:44 AM, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@mellanox.com>
> 
> Add indication about previous failed devlink reload.
> 
> Example outputs:
> 
> $ devlink dev
> netdevsim/netdevsim10: reload_failed true

odd output to user. Why not just "reload failed"?
