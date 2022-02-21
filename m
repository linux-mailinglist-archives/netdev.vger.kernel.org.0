Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8320F4BD33C
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 02:49:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245481AbiBUBrj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 20:47:39 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245458AbiBUBrh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 20:47:37 -0500
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5E48443C9;
        Sun, 20 Feb 2022 17:47:15 -0800 (PST)
Received: by mail-pj1-x1043.google.com with SMTP id iq13-20020a17090afb4d00b001bc4437df2cso919014pjb.2;
        Sun, 20 Feb 2022 17:47:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=YhojBWVK4UiEqGQSq9xm7bnPmCBpgHMKvLchmEMssxs=;
        b=GlK21yrXja4jNo1iNtBTRnPdeFQI5GpeylgO4iDFg+CzXF41SDjFSj8xiPCGjoIYGt
         8GsdIrxUZLSUp895Aek9lp3KaiKcnx+8FG/dZ1Z/bSCNS9TKJMpgrTIU71kbmxNE5GPJ
         d2hFqUN93utB3CZO92u+RdM136S1a9RKYnx9mm2RPtLgHaFWy4WDf6/EuIpk04lnzXa9
         R3SZxb9eK4ZJVuFwuZPYRIBSROenJv2ywEYhuS4Ym8WqDFZTUPlbX1YJ1C9wbLIBgGpv
         RNEKatUz1IqL9dvwziyhI6d8zo+asOlyWCuWEF5OQIPFKBJZShhhy+KZNPkeHambjgWo
         3F/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=YhojBWVK4UiEqGQSq9xm7bnPmCBpgHMKvLchmEMssxs=;
        b=YwGCigK2ikxMi+yMipxztbXUsZ2o3o7F40L0sO16ohaNscdy+FWHbQKmzwrUY+iwwG
         p97ZMqem13EXgAqxj1DphsoFTmG+8U/8c512gtpdNeorGlZWp+JmEkVZitUO1ydOeoHt
         Ud8L36vH9d/lJXO1zjJSwQwXpbWMcC5Cu76fCJEUXAP71CpP7dTv65jzUqb5egUg7+cU
         klbo4FdRn4dC30gPmm3Wnxf8nvu1DmAmcakaqy5aijK3FaM6q13oE5LkPzotI4FRfRLx
         WlcGov/jk62RPj1+7Ejh95RqbhI9w7Q6nd8XFR6aPucUFPScNL3zE/pWffOb2r5CfNkZ
         TD6Q==
X-Gm-Message-State: AOAM530bQAv5Gcz+vCzzKqTC7ZomhCxBHtx0jNNjT6PkM9nDRzZuW/Gb
        cjvuUb65ScqjBCtZjow+6wHbHfuwNp/dQFa2
X-Google-Smtp-Source: ABdhPJwRp23Tcp7DStqEeIUVQutOLb2WR5T9Q1KrYs773Q5FFnrNasoaeqQiUzVYjBNvgbqvFOfAsg==
X-Received: by 2002:a17:90a:1656:b0:1bb:f715:5606 with SMTP id x22-20020a17090a165600b001bbf7155606mr8998633pje.221.1645408035199;
        Sun, 20 Feb 2022 17:47:15 -0800 (PST)
Received: from [10.11.37.162] ([103.84.139.53])
        by smtp.gmail.com with ESMTPSA id c14sm10171380pfv.126.2022.02.20.17.47.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Feb 2022 17:47:14 -0800 (PST)
Message-ID: <a8d5b618-f5ee-686e-d614-dd038004d488@gmail.com>
Date:   Mon, 21 Feb 2022 09:47:09 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] staging: qlge: add unregister_netdev in qlge_probe
Content-Language: en-US
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     manishc@marvell.com, GR-Linux-NIC-Dev@marvell.com,
        coiby.xu@gmail.com, gregkh@linuxfoundation.org,
        netdev@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-kernel@vger.kernel.org
References: <20220218081130.45670-1-hbh25y@gmail.com>
 <20220218120344.GH2407@kadam>
From:   Hangyu Hua <hbh25y@gmail.com>
In-Reply-To: <20220218120344.GH2407@kadam>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for your suggesion. I will resubmit later.

On 2022/2/18 20:03, Dan Carpenter wrote:
> On Fri, Feb 18, 2022 at 04:11:30PM +0800, Hangyu Hua wrote:
>> unregister_netdev need to be called when register_netdev succeeds
>> qlge_health_create_reporters fails.
>>
> 
> 1) Add a Fixes tag:
> 
> Fixes: d8827ae8e22b ("staging: qlge: deal with the case that devlink_health_reporter_create fails")
> 
>> Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
>> ---
>>   drivers/staging/qlge/qlge_main.c | 4 +++-
>>   1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
>> index 9873bb2a9ee4..0a199c6d77a1 100644
>> --- a/drivers/staging/qlge/qlge_main.c
>> +++ b/drivers/staging/qlge/qlge_main.c
>> @@ -4611,8 +4611,10 @@ static int qlge_probe(struct pci_dev *pdev,
>>   	}
>>   
>>   	err = qlge_health_create_reporters(qdev);
>> -	if (err)
>> +	if (err) {
>> +		unregister_netdev(ndev);
>>   		goto netdev_free;
>> +	}
> 
> 2) Use a goto to unwind.  3) Release the other pdev stuff as well.
> 4)  Clean up the error handling for register_netdev() by using a goto
> as well.
> 
> 	err = register_netdev(ndev);
> 	if (err) {
> 		dev_err(&pdev->dev, "net device registration failed.\n");
> 		goto cleanup_pdev;
> 	}
> 
> 	err = qlge_health_create_reporters(qdev);
> 	if (err)
> 		goto unregister_netdev;
> 
> 	...
> 
> 	return 0;
> 
> unregister_netdev:
> 	unregister_netdev(ndev);
> cleanup_pdev:
> 	qlge_release_all(pdev);
> 	pci_disable_device(pdev);
> netdev_free:
> 	free_netdev(ndev);
> devlink_free:
> 	devlink_free(devlink);
> 
> 	return ret;
> 
> regards,
> dan carpenter
> 
