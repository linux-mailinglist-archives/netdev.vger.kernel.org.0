Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A1DC5777FB
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 21:28:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231915AbiGQT14 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jul 2022 15:27:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbiGQT1z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jul 2022 15:27:55 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A109A12AE9
        for <netdev@vger.kernel.org>; Sun, 17 Jul 2022 12:27:54 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id o3-20020a17090a744300b001ef8f7f3dddso10738550pjk.3
        for <netdev@vger.kernel.org>; Sun, 17 Jul 2022 12:27:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=y3btTs/yNuEJu8te84F//HSZxT3yqG9bGZF+OiJzBVc=;
        b=lJLs1jA3edt/XIpEGK/u5i4n2ipF+vX2gOur187F38CFT3Pr6e7wWndwBGP/XcT7Vx
         y/KGBoDnub7mVVCebAoJbH0RgkslrTydGzAw3Mg+8892fYrcMwZTUyRmM+9Gwvbcn+59
         bRL1vktrF9ZSoH+5MvF90+Jz+vGRZJClbpYOETJ57Jj7wx/NL7ohQGiTzC21+7BsycBs
         slkgC+URvLvlwY0eH2P1RiNRrrc3fpE64Nc0KgL750Lxg1Zy1ppwDUemWfOFl3350DHy
         3ZJhmvET82SVLD3Mox2l+lWXE7eaelHXvhJJKVdEJ34S/ejFtEBui4l6d2jE/4sCSwTF
         YYQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=y3btTs/yNuEJu8te84F//HSZxT3yqG9bGZF+OiJzBVc=;
        b=NwQJaguhKRm9Z+oTJ+C5jeLcASCD9KEPQiecpbgnlxu0GrPjKxMbQLGh9yTdVpOS3H
         84rJO061mLfTI0FRuCjMQaYZg9McrzWTPjaVxEtaTWonQGyITKK505ahRS8S/D98oPAe
         IOx7DsBTKZPlKyeINJshiw9q2ipFrPLSK3bCicFrsQX3Ma+aW3rg/PpFOrwSNv2WbhI6
         BMs5qpKkguZ53AbFchsUJpypN1enspP0vvj737nhgXXnw7NYNszYAjC/6fKYvmzRUs1V
         NvFFS7Tbl/EmtVwdWebfZhRYpAq5NQhwmaMoqBZaHCcSbGtfxDpKC7HURpc7zxsigDhB
         mO8Q==
X-Gm-Message-State: AJIora+P4PfRQLCGJ4ObjSIuzb9QkDxGJghnz903EvRayHmIJsILSqmI
        nFygplidUhTBdnOtQIPQcZ4=
X-Google-Smtp-Source: AGRyM1uw1J0gfwI89KoublJko4V2UUvC5iCrEg2mmdYVX76qcyxneE00dxMZIZLrDVnJk3ii1Cxc+g==
X-Received: by 2002:a17:902:e746:b0:16c:4eb6:915d with SMTP id p6-20020a170902e74600b0016c4eb6915dmr24875027plf.106.1658086074191;
        Sun, 17 Jul 2022 12:27:54 -0700 (PDT)
Received: from ?IPV6:2600:8802:b00:4a48:c1c9:5ca7:2a60:8cc5? ([2600:8802:b00:4a48:c1c9:5ca7:2a60:8cc5])
        by smtp.gmail.com with ESMTPSA id j9-20020a170902da8900b0016bfafffa0esm7627628plx.227.2022.07.17.12.27.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 Jul 2022 12:27:53 -0700 (PDT)
Message-ID: <34ec9b2d-d5cd-c724-677f-377ce4acab45@gmail.com>
Date:   Sun, 17 Jul 2022 12:27:52 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: [PATCH net 15/15] docs: net: dsa: mention that VLANs are now
 refcounted on shared ports
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
References: <20220716185344.1212091-1-vladimir.oltean@nxp.com>
 <20220716185344.1212091-16-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220716185344.1212091-16-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/16/2022 11:53 AM, Vladimir Oltean wrote:
> The blamed commit updated the way in which VLANs are handled at the
> cross-chip notifier layer and didn't update the documentation to say
> that. Fix it.
> 
> Fixes: 134ef2388e7f ("net: dsa: add explicit support for host bridge VLANs")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
