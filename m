Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F4C163BA8
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 21:06:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727046AbfGITGD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 15:06:03 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:44497 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726957AbfGITGC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 15:06:02 -0400
Received: by mail-pl1-f194.google.com with SMTP id t14so7482069plr.11
        for <netdev@vger.kernel.org>; Tue, 09 Jul 2019 12:06:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=oHuCgdhnA5jVCMIcoDpWtuhZkW86HdcBcjiraeTbUzo=;
        b=0bNs6LO0/cQFWPyAKjocOywwPN8C325YD0qhmzvrvvV/tQCo0N+e2r2ZGK8JP2CB/Y
         0nuTnwPbpW154skHeViPQ9pyfkIjh1VxL9YDatY6sEvbgpBzpLrmpA23DNQHGbe+49QG
         DrSV1dOGwrR446/l7CwY3zKWP4hBwa7gJrj1oTm5oP4xd+ZsLGBTNBXhdlb506YjpvEn
         lStphS0R/QPaSEYwuk7v/mf1E3+wNX6VZwV+9NCwprghPoAOluAyhD825lt0/B/uiU6n
         ucKfaYipkpGff4vNypQNdA8dXGqo/9Jq2LM+hZNUC2o2eS24hsWaLQaETnEqJBJJmKN+
         3EQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=oHuCgdhnA5jVCMIcoDpWtuhZkW86HdcBcjiraeTbUzo=;
        b=mKENWxoLyUnQZN1SBbp4xkGutz/I7WO80jak/PkZXn+39jWeTYWf86NHVRcyHxIK/t
         xF13ouXhW9tw9+vL3I0fV63+ayAl+ibMfYmDAy7PpSng5Bgf/6ADsbA26w6QKN+aWqvD
         BiIY+miNWtA8KYcfbjfV2Zb+hHg9lT0SrHJd2d/OjMZAk686c0RrOXdtAGs9l5qy/4Ti
         bOSIvmlKVyTnJe4wZUenhzse0hJNbmJb8QuWDYFLi0xep5klNmTpUE7A3wD80TRp8c9K
         9aQpBvWbpY33cPLPw6HzwbHV+r5zsHGjcQV9QFX6mqYj0ssZ2rJ15Qtn83XTSk9CuyvT
         zEvw==
X-Gm-Message-State: APjAAAWNG7ofl7rdStKaRhMVNLlXW2pVEj7Up58uuvedkbCxZaxglLxq
        aDf+xuTMY3C5O5eHZ3TvYl4nv9WAUQk=
X-Google-Smtp-Source: APXvYqw/v7qIasbyJjSn8Ay2fiuEF7+nZxgLWltSsxkxdWNLa9eQY7dZnZnPJmef+alnlX7bc/PJFQ==
X-Received: by 2002:a17:902:9896:: with SMTP id s22mr32628918plp.4.1562699161946;
        Tue, 09 Jul 2019 12:06:01 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id n26sm23105379pfa.83.2019.07.09.12.06.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 09 Jul 2019 12:06:01 -0700 (PDT)
Subject: Re: [PATCH v3 net-next 19/19] ionic: Add basic devlink interface
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org
References: <20190708192532.27420-1-snelson@pensando.io>
 <20190708192532.27420-20-snelson@pensando.io>
 <20190708182654.72446be5@cakuba.netronome.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <dd3d235b-e09f-fcd7-b631-1e206c8ad983@pensando.io>
Date:   Tue, 9 Jul 2019 12:06:58 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <20190708182654.72446be5@cakuba.netronome.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/8/19 6:26 PM, Jakub Kicinski wrote:
> On Mon,  8 Jul 2019 12:25:32 -0700, Shannon Nelson wrote:
>> Add a devlink interface for access to information that isn't
>> normally available through ethtool or the iplink interface.
>>
>> Example:
>> 	$ ./devlink -j -p dev info pci/0000:b6:00.0
>> 	{
>> 	    "info": {
>> 		"pci/0000:b6:00.0": {
>> 		    "driver": "ionic",
>> 		    "serial_number": "FLM18420073",
>> 		    "versions": {
>> 			"fixed": {
>> 			    "fw_version": "0.11.0-50",
> Hm. Fixed is for hardware components. Seeing FW version reported as
> fixed seems counter intuitive.  You probably want "running"?

Sure.

>
>> 			    "fw_status": "0x1",
> I don't think this is the right interface to report status-like
> information.  Perhaps devlink health reporters?
>
>> 			    "fw_heartbeat": "0x716ce",
> Ditto, perhaps best to report it in health stuff?

I haven't dug too far into the health stuff, but on the surface it looks 
like a lot of infrastructure for a couple of simple values. I'm tempted 
to put them back into debugfs for the moment rather than add that much 
more interface goo.

>
>> 			    "asic_type": "0x0",
>> 			    "asic_rev": "0x0"
> These seem like legit "fixed" versions 👍
>
>> 			}
>> 		    }
>> 		}
>> 	    }
>> 	}
>>
>> Signed-off-by: Shannon Nelson <snelson@pensando.io>
> Isn't this a new patch? Perhaps you'd be best off upstreaming the
> first batch of support and add features later? It'd be easier on
> reviewers so we don't have to keep re-checking the first 16 patches..

Yes, and I commented about this in v2 notes: in the tension between 
trying to address comments, keep the line count down, keep the basic 
feature set, and keep the patches self-consistent and simple, I added 
this one patch for the devlink goodies that were requested. At least the 
total line count went down.

sln


