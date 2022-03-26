Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE734E840F
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 21:12:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234915AbiCZUNc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Mar 2022 16:13:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231216AbiCZUN3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Mar 2022 16:13:29 -0400
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29828241B4A;
        Sat, 26 Mar 2022 13:11:52 -0700 (PDT)
Received: by mail-oi1-x22d.google.com with SMTP id t21so6872808oie.11;
        Sat, 26 Mar 2022 13:11:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=vyogW6pRw4TxMLFH/OAI8i2CuCNMUPvPn6TqY6UMRzs=;
        b=qI8+/rISiLM4S3syiolkBDrkAn5rJnAaX415CYTjx4dKVSFumFrpFURbiHG98m81qZ
         il0OlcEK1TKIHYiFISMHEXl/2QE2f2YHTVL8KZr5QcDlrxOgTuo4L7bk7uZwjMzv2Poj
         IfKJcRcQihpadC6DT8x0J2AlcVlZY9Eh7bh86qF4oGx5VYuAALMDWURmuCjdTmADsS4e
         E1ji/kD2o/eWDlmbxvqnNO9T84DF4D0GaCgOoKzOtshqe3skLjnJfXCSjuDLaj1fWR+W
         t2slUWX0zvkba+impWisaY+5nTg6FTnZWYwj4++z/ucX0dJ7gjmdh5ZD2lrilTA678Iw
         6q2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=vyogW6pRw4TxMLFH/OAI8i2CuCNMUPvPn6TqY6UMRzs=;
        b=75w1JpUQupmVyaaQVVyi5Qv7KgJauJoswzPt/uTIgQmv8EwyTzj3FoFMYSXdwqwOO7
         fWZ434+4yu231QNWAJigzewaPT6Q9ad10CK5FQVfVrC4RQwWs5MqVay37fwTbJbLObTJ
         u1YdjNHvABP9OUZuwmt9BQtaN4bbnwrAGNE2H8IfjwVRoCJsUznHanbJ3fdwXgfT8GFa
         8T/FHtmz5YAasnynh2FkmzKIHq7t9eWRPFolvBj8BHvEC2KNQIdlzr7IVpxzVY2Ihvff
         1R5DhvAz+qVqGETkC+aktb91BFHmC7ZJitgJ7fW2jK14F8hw02vlOkUAGHOHUQMSig9Y
         gnMw==
X-Gm-Message-State: AOAM533mD1tEm+oxLm/p6cBF8WSnWh389XrpzOfkHNQCystXigUdTnlH
        tnPNIpbx7Q+1oLtHFu1LhTs=
X-Google-Smtp-Source: ABdhPJyyr/4gW2/fe8vL0CKJWbjKHQtaF6ZLN/tkmapCcqJDYnd7L4lOtPa78xKHoEUrtbuk1DYsgg==
X-Received: by 2002:a05:6808:124d:b0:2d7:f6e:74b0 with SMTP id o13-20020a056808124d00b002d70f6e74b0mr13131949oiv.141.1648325511202;
        Sat, 26 Mar 2022 13:11:51 -0700 (PDT)
Received: from [192.168.1.103] (cpe-24-31-246-181.kc.res.rr.com. [24.31.246.181])
        by smtp.gmail.com with ESMTPSA id y67-20020a4a4546000000b0032476e1cb40sm4526071ooa.25.2022.03.26.13.11.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 26 Mar 2022 13:11:50 -0700 (PDT)
Sender: Larry Finger <larry.finger@gmail.com>
Message-ID: <bc2d4f83-0674-ccae-71c8-14427de59f96@lwfinger.net>
Date:   Sat, 26 Mar 2022 15:11:46 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 16/22] dvb-usb: Replace comments with C99 initializers
Content-Language: en-US
To:     Joe Perches <joe@perches.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        =?UTF-8?Q?Benjamin_St=c3=bcrz?= <benni@stuerz.xyz>
Cc:     andrew@lunn.ch, sebastian.hesselbarth@gmail.com,
        gregory.clement@bootlin.com, linux@armlinux.org.uk,
        linux@simtec.co.uk, krzk@kernel.org, alim.akhtar@samsung.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, robert.moore@intel.com,
        rafael.j.wysocki@intel.com, lenb@kernel.org, 3chas3@gmail.com,
        laforge@gnumonks.org, arnd@arndb.de, gregkh@linuxfoundation.org,
        tony.luck@intel.com, james.morse@arm.com, rric@kernel.org,
        linus.walleij@linaro.org, brgl@bgdev.pl,
        mike.marciniszyn@cornelisnetworks.com,
        dennis.dalessandro@cornelisnetworks.com, jgg@ziepe.ca,
        pali@kernel.org, dmitry.torokhov@gmail.com, isdn@linux-pingi.de,
        benh@kernel.crashing.org, fbarrat@linux.ibm.com, ajd@linux.ibm.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        nico@fluxnic.net, loic.poulain@linaro.org, kvalo@kernel.org,
        pkshih@realtek.com, bhelgaas@google.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-ia64@vger.kernel.org,
        linux-acpi@vger.kernel.org, devel@acpica.org,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-edac@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-input@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-media@vger.kernel.org,
        wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-pci@vger.kernel.org
References: <20220326165909.506926-1-benni@stuerz.xyz>
 <20220326165909.506926-16-benni@stuerz.xyz>
 <20220326192454.14115baa@coco.lan> <20220326192720.0fddd6dd@coco.lan>
 <63a5e3143e904d1391490f27cc106be894b52ca2.camel@perches.com>
From:   Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <63a5e3143e904d1391490f27cc106be894b52ca2.camel@perches.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UPPERCASE_50_75
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/26/22 14:51, Joe Perches wrote:
> On Sat, 2022-03-26 at 19:27 +0100, Mauro Carvalho Chehab wrote:
>> Em Sat, 26 Mar 2022 19:24:54 +0100
>> Mauro Carvalho Chehab <mchehab@kernel.org> escreveu:
>>
>>> Em Sat, 26 Mar 2022 17:59:03 +0100
>>> Benjamin Stürz <benni@stuerz.xyz> escreveu:
>>>
>>>> This replaces comments with C99's designated
>>>> initializers because the kernel supports them now.
>>>>
>>>> Signed-off-by: Benjamin Stürz <benni@stuerz.xyz>
>>>> ---
>>>>   drivers/media/usb/dvb-usb/dibusb-mb.c | 62 +++++++++++++--------------
>>>>   drivers/media/usb/dvb-usb/dibusb-mc.c | 34 +++++++--------
>>>>   2 files changed, 48 insertions(+), 48 deletions(-)
>>>>
>>>> diff --git a/drivers/media/usb/dvb-usb/dibusb-mb.c b/drivers/media/usb/dvb-usb/dibusb-mb.c
>>>> index e9dc27f73970..f188e07f518b 100644
>>>> --- a/drivers/media/usb/dvb-usb/dibusb-mb.c
>>>> +++ b/drivers/media/usb/dvb-usb/dibusb-mb.c
>>>> @@ -122,40 +122,40 @@ static int dibusb_probe(struct usb_interface *intf,
>>>>   
>>>>   /* do not change the order of the ID table */
>>>>   static struct usb_device_id dibusb_dib3000mb_table [] = {
>>>> -/* 00 */	{ USB_DEVICE(USB_VID_WIDEVIEW,		USB_PID_AVERMEDIA_DVBT_USB_COLD) },
>>>> -/* 01 */	{ USB_DEVICE(USB_VID_WIDEVIEW,		USB_PID_AVERMEDIA_DVBT_USB_WARM) },
>>>> -/* 02 */	{ USB_DEVICE(USB_VID_COMPRO,		USB_PID_COMPRO_DVBU2000_COLD) },
>>>> -/* 03 */	{ USB_DEVICE(USB_VID_COMPRO,		USB_PID_COMPRO_DVBU2000_WARM) },
>>>> -/* 04 */	{ USB_DEVICE(USB_VID_COMPRO_UNK,	USB_PID_COMPRO_DVBU2000_UNK_COLD) },
>>>> -/* 05 */	{ USB_DEVICE(USB_VID_DIBCOM,		USB_PID_DIBCOM_MOD3000_COLD) },
>>>> -/* 06 */	{ USB_DEVICE(USB_VID_DIBCOM,		USB_PID_DIBCOM_MOD3000_WARM) },
>>>> -/* 07 */	{ USB_DEVICE(USB_VID_EMPIA,		USB_PID_KWORLD_VSTREAM_COLD) },
>>>> -/* 08 */	{ USB_DEVICE(USB_VID_EMPIA,		USB_PID_KWORLD_VSTREAM_WARM) },
>>>> -/* 09 */	{ USB_DEVICE(USB_VID_GRANDTEC,		USB_PID_GRANDTEC_DVBT_USB_COLD) },
>>>> -/* 10 */	{ USB_DEVICE(USB_VID_GRANDTEC,		USB_PID_GRANDTEC_DVBT_USB_WARM) },
>>>> -/* 11 */	{ USB_DEVICE(USB_VID_GRANDTEC,		USB_PID_DIBCOM_MOD3000_COLD) },
>>>> -/* 12 */	{ USB_DEVICE(USB_VID_GRANDTEC,		USB_PID_DIBCOM_MOD3000_WARM) },
>>>> -/* 13 */	{ USB_DEVICE(USB_VID_HYPER_PALTEK,	USB_PID_UNK_HYPER_PALTEK_COLD) },
>>>> -/* 14 */	{ USB_DEVICE(USB_VID_HYPER_PALTEK,	USB_PID_UNK_HYPER_PALTEK_WARM) },
>>>> -/* 15 */	{ USB_DEVICE(USB_VID_VISIONPLUS,	USB_PID_TWINHAN_VP7041_COLD) },
>>>> -/* 16 */	{ USB_DEVICE(USB_VID_VISIONPLUS,	USB_PID_TWINHAN_VP7041_WARM) },
>>>> -/* 17 */	{ USB_DEVICE(USB_VID_TWINHAN,		USB_PID_TWINHAN_VP7041_COLD) },
>>>> -/* 18 */	{ USB_DEVICE(USB_VID_TWINHAN,		USB_PID_TWINHAN_VP7041_WARM) },
>>>> -/* 19 */	{ USB_DEVICE(USB_VID_ULTIMA_ELECTRONIC,	USB_PID_ULTIMA_TVBOX_COLD) },
>>>> -/* 20 */	{ USB_DEVICE(USB_VID_ULTIMA_ELECTRONIC,	USB_PID_ULTIMA_TVBOX_WARM) },
>>>> -/* 21 */	{ USB_DEVICE(USB_VID_ULTIMA_ELECTRONIC,	USB_PID_ULTIMA_TVBOX_AN2235_COLD) },
>>>> -/* 22 */	{ USB_DEVICE(USB_VID_ULTIMA_ELECTRONIC,	USB_PID_ULTIMA_TVBOX_AN2235_WARM) },
>>>> -/* 23 */	{ USB_DEVICE(USB_VID_ADSTECH,		USB_PID_ADSTECH_USB2_COLD) },
>>>> +[0]  =	{ USB_DEVICE(USB_VID_WIDEVIEW,		USB_PID_AVERMEDIA_DVBT_USB_COLD) },
>>>> +[1]  =	{ USB_DEVICE(USB_VID_WIDEVIEW,		USB_PID_AVERMEDIA_DVBT_USB_WARM) },
>>>
>>> While here, please properly indent this table, and respect the 80-columns limit,
>>> e. g.:
>>>
>>> static struct usb_device_id dibusb_dib3000mb_table [] = {
>>> 	[0] = { USB_DEVICE(USB_VID_WIDEVIEW
>>> 			   USB_PID_AVERMEDIA_DVBT_USB_COLD)
>>> 	},
>>> 	[1]  =	{ USB_DEVICE(USB_VID_WIDEVIEW,
>>> 			     USB_PID_AVERMEDIA_DVBT_USB_WARM)
>>> 	},
>>> 	...
>>
>> Err.... something went wrong with my space bar and I ended hitting send to
>> soon... I meant:
>>
>> static struct usb_device_id dibusb_dib3000mb_table [] = {
>>   	[0] = { USB_DEVICE(USB_VID_WIDEVIEW
>>   			   USB_PID_AVERMEDIA_DVBT_USB_COLD)
>>   	},
>>   	[1] = { USB_DEVICE(USB_VID_WIDEVIEW,
>>   			   USB_PID_AVERMEDIA_DVBT_USB_WARM)
>>   	},
>> 	...
>> };
> 
> maybe static const too
> 
> and
> 
> maybe
> 
> #define DIB_DEVICE(vid, pid)	\
> 	{ USB_DEVICE(USB_VID_ ## vid, USB_PID_ ## pid) }
> 
> so maybe
> 
> static const struct usb_device_id dibusb_dib3000mb_table[] = {
> 	[0] = DIB_DEVICE(WIDEVIEW, AVERMEDIA_DVBT_USB_COLD),
> 	[1] = DIB_DEVICE(WIDEVIEW, AVERMEDIA_DVBT_USB_WARM),
> 	...
> };
> 
> though I _really_ doubt the value of the specific indexing.
> 
> I think this isn't really worth changing at all.

I agree. For the drivers that I maintain, I try to keep the vendor and device 
ids in numerical order. As this table does not require a special order, adding a 
new one in the middle would require redoing all of then after that point. That 
would be pointless work!

Larry
