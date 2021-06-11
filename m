Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A9C23A39D4
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 04:36:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231287AbhFKCiF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 22:38:05 -0400
Received: from mail-ot1-f50.google.com ([209.85.210.50]:38640 "EHLO
        mail-ot1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230160AbhFKCiF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 22:38:05 -0400
Received: by mail-ot1-f50.google.com with SMTP id j11-20020a9d738b0000b02903ea3c02ded8so1749990otk.5
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 19:36:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nCHPjgidBaFl/yWAffnmU8OdIOw/DsEmB+bsIp+Cu8A=;
        b=mcFtj0oJnlqavv8236iAEiE94L9wkmFYUF90XMJ5kG35/jYXDBguVI2bzCA6nGkW/j
         EXxo8QoIBn70ovX22DJmmN/HhFc0kwZROqfZZ4XnXSi+PM1Q9qhoMVgMgG5utPz+W3eM
         ZLdyw3UFjQy8eqijrE1QD7cQ0M4KQPvGqGhcdo6Oh7INNgu3ffAcc/0safpKTRpqoasw
         4xlWfpzo/POBNc3NtUIWPX2+KtQpG+Cazt3jaJZS+RzQKM3SN2x19PI8jA5qmq1qqVpJ
         9zwqAMwBF0Y2tqshEFcx3mphgW+HrDuQtdT90wKPiO7qrqiHuz8wrZChfwQHklN3XxB8
         gFRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nCHPjgidBaFl/yWAffnmU8OdIOw/DsEmB+bsIp+Cu8A=;
        b=i5y0swvoL6x06OsgA+lgISoPThJXN5VYhrMSTtR0DFtiZf9jxNtjRrbINhQkXwjMm7
         Mv9pHFU1VbE5kBDlaT2HnF9fahBfPtZw2baiZQUqFbEwrVeBQw4xW7qP81K5cbiZjpTr
         dXrs/C4IHnzNnQU9RgPqKF3QBuo5yjJmt6Fhp0gaW048MrwamusUiahG37u8nZ1vLRrO
         8SQWJrjzgaSKQKA1qVUVM/WM0frSgbK7FbxCXghLK2PJvY07JVIxnO6hwwLgtDtRmVok
         86JbxprMdsVTqd5rrzQd8w3Ao73kdZQKSqUKCfrIyhc9C0NCr8SW4jB8vEEpNyvYAjDt
         fIHA==
X-Gm-Message-State: AOAM5323f0Abxo2XP+lzRHlXIoW7bGdkf+zm0jzQ/aChVFezaYL98B2d
        HojcuDeLBrW/l2D2uh8zuKH/H89/ZiY=
X-Google-Smtp-Source: ABdhPJx9UfZ8Q9Bw/mbpjSVt37Vz/cgYbWdagCRFNcunHDv1ExIlRRl+7whxx4V8nxM8AJ0wIjfnig==
X-Received: by 2002:a05:6830:2117:: with SMTP id i23mr1045837otc.279.1623378907874;
        Thu, 10 Jun 2021 19:35:07 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.22])
        by smtp.googlemail.com with ESMTPSA id 184sm887615ooi.3.2021.06.10.19.35.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Jun 2021 19:35:06 -0700 (PDT)
Subject: Re: [PATCH iproute2-next v4 1/1] police: Add support for json output
To:     Roi Dayan <roid@nvidia.com>, netdev@vger.kernel.org
Cc:     Paul Blakey <paulb@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>
References: <20210607064408.1668142-1-roid@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <b2d21f24-2b76-710c-f895-2c803ffa4d78@gmail.com>
Date:   Thu, 10 Jun 2021 20:35:05 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210607064408.1668142-1-roid@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/7/21 12:44 AM, Roi Dayan wrote:
> Change to use the print wrappers instead of fprintf().
> 
> This is example output of the options part before this commit:
> 
>         "options": {
>             "handle": 1,
>             "in_hw": true,
>             "actions": [ {
>                     "order": 1 police 0x2 ,
>                     "control_action": {
>                         "type": "drop"
>                     },
>                     "control_action": {
>                         "type": "continue"
>                     }overhead 0b linklayer unspec
>         ref 1 bind 1
> ,
>                     "used_hw_stats": [ "delayed" ]
>                 } ]
>         }
> 
> This is the output of the same dump with this commit:
> 
>         "options": {
>             "handle": 1,
>             "in_hw": true,
>             "actions": [ {
>                     "order": 1,
>                     "kind": "police",
>                     "index": 2,
>                     "control_action": {
>                         "type": "drop"
>                     },
>                     "control_action": {
>                         "type": "continue"
>                     },
>                     "overhead": 0,
>                     "linklayer": "unspec",
>                     "ref": 1,
>                     "bind": 1,
>                     "used_hw_stats": [ "delayed" ]
>                 } ]
>         }
> 
> Signed-off-by: Roi Dayan <roid@nvidia.com>
> Reviewed-by: Paul Blakey <paulb@nvidia.com>
> ---
> 
> Notes:
>     v2
>     - fix json output to match correctly the other actions
>       i.e. output the action name in key 'kind' and unsigned for the index
>     
>     v3
>     - print errors to stderr.
>     - return -1 on null key.
>     
>     v4
>     - removed left over debug that was forgotten. sorry for that.
> 
>  tc/m_police.c | 30 +++++++++++++++++-------------
>  1 file changed, 17 insertions(+), 13 deletions(-)
> 

applied to iproute2-next

