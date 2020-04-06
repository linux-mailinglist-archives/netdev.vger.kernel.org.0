Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F54619FC7E
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 20:06:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbgDFSGj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 14:06:39 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:40722 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726530AbgDFSGj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 14:06:39 -0400
Received: by mail-wr1-f65.google.com with SMTP id s8so557931wrt.7
        for <netdev@vger.kernel.org>; Mon, 06 Apr 2020 11:06:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=70URWwjZCBpvtwiUWI7tNhDiEyKOh0lXOWNvFVOTj38=;
        b=n0lh1431yTgQU5kOgnqlmRpwaEUVUjgLakF5zq4FC9qNcumRVjbwVuAlaymiH++nRE
         nE1SLaBgmBjnagoI54ZCObvr9qet4O1o1XGo2FdGCzZKe//3YFnZZfKJUGBpXP6qbMdR
         qewiLIqcuJcCWmQlwVv/WAAw1g8OZyRrVukYSMW85uv5wungCQwjpcARy6liy52N4bZu
         E5augtTiyCbBHcgaUogMsyqQD8DMoAcjOaa7Exp1jAIa4ECFnbYCEEQPu7QFr/ZfbWKx
         zzi6VvI5efMrVpdW3SgDeHHj/HQx77nFDvCQuOjKfmh46CUr64HFErh3Fld8XNg/+2qD
         HIJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=70URWwjZCBpvtwiUWI7tNhDiEyKOh0lXOWNvFVOTj38=;
        b=Yfl3+hyNsSlousFUe9Eizf7jJO6WSJ5KTsEelpuDCIo9496xij5j30iOQ3sHtQIOfV
         t/aENRvdHp7qW+OHj14ez0zhwPGN3dphSsE2sYGHIlup+rEPM8BBOqg6B3phbPnWlkgY
         gCZyGhlCiiU5/u1rkXBKTTuwWaDrwzzepU4mXlT7uZ+TY+DtZAPPRxYM80/lJ7PnW5+X
         XWUXa7NxlLcApj1ENqPvGY6jC52/gdrH86R8anUmRfCVmO2axl87y2bX/OsMVwhYRx5p
         8Z02g9amBVlY3f/2lvJ32w/i+E7S/v/sHiJ2cvzvr8JfBaiP5B1utoke5nk5NSgX9WCF
         7IqA==
X-Gm-Message-State: AGi0PuZ0g+x4z/grZV6hP5X9MJ81jT2PUgAIJ8yxs6pYmbwj3z5A1/zY
        9uGxGXN9jEOX81OhU75F42uITw==
X-Google-Smtp-Source: APiQypKmlDF5+aQhhXjJbEbEY1LXsV0Uv63KqW9WqbiNo1kGHDUcG1Fu9iZ23GnN7H4xPc2KRvYAnw==
X-Received: by 2002:adf:ec4c:: with SMTP id w12mr439577wrn.240.1586196397091;
        Mon, 06 Apr 2020 11:06:37 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id f12sm27697431wrm.94.2020.04.06.11.06.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Apr 2020 11:06:36 -0700 (PDT)
Date:   Mon, 6 Apr 2020 20:06:35 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com, mlxsw@mellanox.com
Subject: Re: [patch iproute2/net-next 8/8] man: add man page for devlink dpipe
Message-ID: <20200406180635.GC2354@nanopsycho.orion>
References: <20200404161621.3452-1-jiri@resnulli.us>
 <20200404161621.3452-9-jiri@resnulli.us>
 <20200406103036.2ac9c665@hermes.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200406103036.2ac9c665@hermes.lan>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Apr 06, 2020 at 07:30:36PM CEST, stephen@networkplumber.org wrote:
>On Sat,  4 Apr 2020 18:16:21 +0200
>Jiri Pirko <jiri@resnulli.us> wrote:
>
>> From: Jiri Pirko <jiri@mellanox.com>
>> 
>> Add simple man page for devlink dpipe.
>> 
>> Signed-off-by: Jiri Pirko <jiri@mellanox.com>
>> ---
>>  man/man8/devlink-dpipe.8 | 100 +++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 100 insertions(+)
>>  create mode 100644 man/man8/devlink-dpipe.8
>> 
>> diff --git a/man/man8/devlink-dpipe.8 b/man/man8/devlink-dpipe.8
>> new file mode 100644
>> index 000000000000..00379401208e
>> --- /dev/null
>> +++ b/man/man8/devlink-dpipe.8
>> @@ -0,0 +1,100 @@
>> +.TH DEVLINK\-DPIPE 8 "4 Apr 2020" "iproute2" "Linux"
>> +.SH NAME
>> +devlink-dpipe \- devlink dataplane pipeline visualization 
>> +.SH SYNOPSIS
>> +.sp
>> +.ad l
>> +.in +8
>> +.ti -8
>> +.B devlink
>> +.RI "[ " OPTIONS " ]"
>> +.B dpipe
>> +.RB "{ " table " | " header " }"
>> +.RI "{ " COMMAND " | "
>> +.BR help " }"
>> +.sp
>> +
>> +.ti -8
>> +.IR OPTIONS " := { "
>> +\fB\-V\fR[\fIersion\fR] }
>> +
>> +.ti -8
>> +.BI "devlink dpipe table show " DEV
>> +.R [
>> +.BI name " TABLE_NAME "
>> +.R ]
>
>I applied the whole set, but fixed some issues on the man page.
>You had some trailing white space, and the .R macro is not the right
>way to do this. Make check runs a script from Debian and it spots that.

Okay. I'll make sure to run this next time. I had no idea it checkes
man. Thanks!
