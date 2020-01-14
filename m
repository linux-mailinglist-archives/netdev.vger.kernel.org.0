Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 724EF139FF3
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 04:27:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729530AbgAND1K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 22:27:10 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:45425 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728802AbgAND1K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 22:27:10 -0500
Received: by mail-io1-f66.google.com with SMTP id i11so12225121ioi.12;
        Mon, 13 Jan 2020 19:27:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=NdHwss5c0gFIX5FaAZPICDBlWdT07YSHa5J4ZYcV8kg=;
        b=qOqoA/y+BV0wRnH8dlAm42FVWDuBmqn8BMW+QIc2cwji2fhOxO14oWoK8VwEzmR4Kv
         HD1jM05+LDfCorK2E9usu+94SpICKBf5euPP7l5x7FrD7nMjDovcM+qW9Iw6QKz318+M
         uCHfApEGl+qszsouUbRJ5v7/rwj85WAoFthdq9ZpPMckVmJuMbRvxfiG47aDfSiopT+N
         PooMUUtat93BNmc8SdA7D3vPqpWYf4hEUnJBhhJtmd5IrPK69LUgb57UMB5iBHv+M6JF
         FRak/fXXIzt/JRx6jWV9LSwRBCDmlBmhyCurPJyrlnAU9kgsTvmn8FoQTNnjfrJ0LMs+
         jYYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=NdHwss5c0gFIX5FaAZPICDBlWdT07YSHa5J4ZYcV8kg=;
        b=S1CbRChrMtAw9HhOXOK6TatrI5lcFE+SC5FGT/iGXtqfSZBBydZSSvbFldaXVab4Ej
         0ArtqwdoWpevkLA953b74vSwkHyg4XppXRxbY9uOJcGYMLPb+JoAEIJlnh7XgNicsgV5
         ZjzjSkm6KNsD2xbGTrlvJTnxYaotYNn7WcuYZuCUb5cje2K2+Ll+ReAWrgpaEwwZ3zcs
         Qc0dmPX+IYhL2cP7zw76pF1TR9pmK2yF5mmmkv31t3aqjF4UzN/AqurU9sgcMvqCWAAx
         yDo69iifZ/iYSxZ2wttys/wStiWnpH6uNKi1OPug6PUraWTZZlmi1QCB7ayfhRPH/yoW
         37FA==
X-Gm-Message-State: APjAAAXFr0WV4MbWC7sk05Boph/0O7uSu8tLnjT79AEMzTUuLghmE7BR
        XO6ASlqbAK8cY3wkJFm+O+g=
X-Google-Smtp-Source: APXvYqzTtkDB4NLN3gsklDMwM8y32KEJIW8VZ33GjmH7itmbbfysYjOtURHYmuFUyZInvmfqasIRCQ==
X-Received: by 2002:a5e:d616:: with SMTP id w22mr14666792iom.57.1578972429125;
        Mon, 13 Jan 2020 19:27:09 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id x13sm3124783ioj.80.2020.01.13.19.27.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jan 2020 19:27:08 -0800 (PST)
Date:   Mon, 13 Jan 2020 19:27:00 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     bjorn.topel@gmail.com, bpf@vger.kernel.org, toke@redhat.com,
        toshiaki.makita1@gmail.com, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net
Message-ID: <5e1d3504820a_78752af1940225b491@john-XPS-13-9370.notmuch>
In-Reply-To: <20200112074722.GA24420@ranger.igk.intel.com>
References: <157879606461.8200.2816751890292483534.stgit@john-Precision-5820-Tower>
 <157879664156.8200.4955971883120344808.stgit@john-Precision-5820-Tower>
 <20200112074722.GA24420@ranger.igk.intel.com>
Subject: Re: [bpf-next PATCH v2 1/2] bpf: xdp, update devmap comments to
 reflect napi/rcu usage
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Maciej Fijalkowski wrote:
> On Sat, Jan 11, 2020 at 06:37:21PM -0800, John Fastabend wrote:
> 
> Small nits for typos, can be ignored.

thanks better to not have typos and I'll send a v3 anyways
for the rcu_access_pointer comment in virtio_net.
