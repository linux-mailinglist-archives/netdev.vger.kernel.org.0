Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0669E4C24CA
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 08:56:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231339AbiBXHys (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 02:54:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230265AbiBXHyr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 02:54:47 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74C67235849;
        Wed, 23 Feb 2022 23:54:18 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id n14so1246173wrq.7;
        Wed, 23 Feb 2022 23:54:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:reply-to:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=P/QdCt/Tgr1NhGv8Wt2qx0d+ksy5gHYVcGOQ9sIcJi4=;
        b=FC1gu07hwptBvAiJyvyQlIWguTtl6iYIN+0yCgXNTS8HoKUXnb0lI7ElLjogLeRCrJ
         nyyndEgk+C2pAA1WJTMmQluBDA7+WKtQYmpr+7PVQffjR+HSjvY5W5xN/ubBgu2JuT6k
         fnvE2+w0d8dirZbj1nl2o9Xe4ZQ6/lfFmmV3nrvfOQaQ0Hy6+3GxjD4yTNSs7lv/FECs
         /sZ6jQj7Cb3dCNq/dxlZrW77WfG9jNlC/t8oWdrGTimv80iIHkh015FByHVRFiVEK7i+
         LBolPGJrQdcUswi/xfW9kC5Cb+O9fxLZdwU8hjKG7tAvaE5PwU3YZRC4t7NyIwtScsgT
         fZgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:reply-to
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=P/QdCt/Tgr1NhGv8Wt2qx0d+ksy5gHYVcGOQ9sIcJi4=;
        b=W3qHNIgl7rE3953mfIiBg6CXkBQof/ITv/Ah65Vr7GoVRXHb0vPWZjiEWQGwATmxnG
         qb5DSAOuER5zu36s7ZZECSW0zFYJ2bRFCmLcsEy+GH/3O+XTPAzB8huyAHBdtvGUlqKv
         k+0qgDKHBEsUv85z1+170bHTCG9df2jaKVXkyxltJCn9DDeXIwpyZVVZbn23kdeXtwwa
         fLU29/gNh/kVNXHVm25ev6i4liPzN+JXnoxtW8S0U7TwOFMGStj9213NPMp8E0cSUnCU
         i8MTXxMzJ6UfGt+gw1sSAVExwEDDf8NH8urqeslGC28VlS4mNueLmM+dogQjaO36qJN4
         zZCA==
X-Gm-Message-State: AOAM533g5qWtwBow8Z2AFGblwpzC6PR3SEmcjazYBMS1tp008taVmGuh
        5ozGFKDL+gGDQjA+SfzqgfDFbZGzFALyPQ==
X-Google-Smtp-Source: ABdhPJy1SdIn3EKk8TBCGbyeJk5RfTnMOzot3SLzXajRYRUsTBYg6N0saeU2O/sDUJjf2kIWIm0WTg==
X-Received: by 2002:a5d:64c6:0:b0:1e8:ee04:e8fb with SMTP id f6-20020a5d64c6000000b001e8ee04e8fbmr1172924wri.518.1645689256968;
        Wed, 23 Feb 2022 23:54:16 -0800 (PST)
Received: from ?IPV6:2a00:23c5:5785:9a01:b013:cd66:72b0:92c8? ([2a00:23c5:5785:9a01:b013:cd66:72b0:92c8])
        by smtp.gmail.com with ESMTPSA id v7sm591707wrr.41.2022.02.23.23.54.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Feb 2022 23:54:16 -0800 (PST)
Message-ID: <dae477f8-1593-4eda-adb1-fa6845e5f993@gmail.com>
Date:   Thu, 24 Feb 2022 07:54:15 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Reply-To: paul@xen.org
Subject: Re: [PATCH v2 1/2] Revert "xen-netback: remove 'hotplug-status' once
 it has served its purpose"
Content-Language: en-US
To:     =?UTF-8?Q?Marek_Marczykowski-G=c3=b3recki?= 
        <marmarek@invisiblethingslab.com>, linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Michael Brown <mcb30@ipxe.org>,
        Wei Liu <wei.liu@kernel.org>, Paul Durrant <paul@xen.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "moderated list:XEN NETWORK BACKEND DRIVER" 
        <xen-devel@lists.xenproject.org>,
        "open list:XEN NETWORK BACKEND DRIVER" <netdev@vger.kernel.org>
References: <20220222001817.2264967-1-marmarek@invisiblethingslab.com>
From:   "Durrant, Paul" <xadimgnik@gmail.com>
In-Reply-To: <20220222001817.2264967-1-marmarek@invisiblethingslab.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22/02/2022 00:18, Marek Marczykowski-Górecki wrote:
> This reverts commit 1f2565780e9b7218cf92c7630130e82dcc0fe9c2.
> 
> The 'hotplug-status' node should not be removed as long as the vif
> device remains configured. Otherwise the xen-netback would wait for
> re-running the network script even if it was already called (in case of
> the frontent re-connecting). But also, it _should_ be removed when the
> vif device is destroyed (for example when unbinding the driver) -
> otherwise hotplug script would not configure the device whenever it
> re-appear.
> 
> Moving removal of the 'hotplug-status' node was a workaround for nothing
> calling network script after xen-netback module is reloaded. But when
> vif interface is re-created (on xen-netback unbind/bind for example),
> the script should be called, regardless of who does that - currently
> this case is not handled by the toolstack, and requires manual
> script call. Keeping hotplug-status=connected to skip the call is wrong
> and leads to not configured interface.
> 
> More discussion at
> https://lore.kernel.org/xen-devel/afedd7cb-a291-e773-8b0d-4db9b291fa98@ipxe.org/T/#u
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>

Reviewed-by: Paul Durrant <paul@xen.org>
