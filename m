Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF76D52B210
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 08:06:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230422AbiERGBz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 02:01:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230392AbiERGBx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 02:01:53 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 853545FAF;
        Tue, 17 May 2022 23:01:52 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id v11so1192677pff.6;
        Tue, 17 May 2022 23:01:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jwUhUhiM9K9g0bqA0niln4ofcMzM4SY5gk4unv8ulfY=;
        b=MQsQmDpH+qbLKqbWMOXC3gUVadoesBZNRHV/LrZi3PHOhWFxX+e63RC82IjsjqY3SI
         1oxUcg0cVkSxDwEAhqMGbskhwAMom/ukUujUoOa2nRTFWK3K8aPefYazEZwqePkFDYm6
         dXU8ePC/9wqb9NySdrhK8j4eaN8qiYZ9vKTR05E0mRMZJT0nUamM8P8BH+fpy7rx/xcA
         /Wtz+gKLsMvi7fqIxCXQTiN/vq6d+G83I6dINZO7DVbwlGPH5NStTtgLRMdTdFwrpXvV
         IfEerYgS22O7MHN1jKjUVW5m8bqvxvmHdbMYiJpzxORz/p/6Jj7XIIm0ICMReqeGLXT3
         rgIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jwUhUhiM9K9g0bqA0niln4ofcMzM4SY5gk4unv8ulfY=;
        b=7xJ8aFUV4l8lxraY+9LhImvSOnYp2+JTU4JLiOmNntSQV37q7VWD9itQNp3LirrFvD
         rOFaCna2PkYCvj0hGLTQNxDy5pmnz59/+5sFfvgrCQkQYJpRxx9OELoskrJHtH1d144z
         VpwQZLfl5D2gn8eBASb9ht/WGjxpLi6WgS3Wij7lACNQgDsaZej7etjNGOni7+7H9sYv
         m+2I5FCE8V58k/OBr3F5PJgtPktVLBpiHKkN55tePuwj4lDstzOBw+Ng13KJWl+MHEE6
         Q+v7uEUHxjsMaFIsNmHdfIMhsRfKcOJ2T281osbhzmpUVg/LA7pxjMSWQufBCPba62G/
         xMOw==
X-Gm-Message-State: AOAM530/XkeOkH+ZsAVUeFihVwyu5WvRFwoCblhbXWtb3c+9gIrnCjcZ
        75oo6aoA8Lhar+8Tl/0XXOw=
X-Google-Smtp-Source: ABdhPJwZYH10W7rWVbI6994R3+PUWKLCz3krwqlpyp4shSI2+0HE5rGn70p540G6nFa1N1lRvpNdpA==
X-Received: by 2002:a05:6a00:2187:b0:50c:ef4d:ef3b with SMTP id h7-20020a056a00218700b0050cef4def3bmr25554170pfi.83.1652853711972;
        Tue, 17 May 2022 23:01:51 -0700 (PDT)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id o124-20020a634182000000b003f5dbb3bb6csm589349pga.91.2022.05.17.23.01.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 23:01:51 -0700 (PDT)
Date:   Wed, 18 May 2022 14:01:43 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH net 0/2] selftests: net: add missing tests to Makefile
Message-ID: <YoSLx329qjT4Vrev@Laptop-X1>
References: <20220428044511.227416-1-liuhangbin@gmail.com>
 <20220429175604.249bb2fb@kernel.org>
 <YoM/Wr6FaTzgokx3@Laptop-X1>
 <20220517124517.363445f4@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220517124517.363445f4@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 17, 2022 at 12:45:17PM -0700, Jakub Kicinski wrote:
> Yes, we don't have the auto-reply. There's too much noise in some of
> the tests, but mostly it's because we don't want to encourage people
> posting patches just to build them. If it's a machine replying rather
> than a human some may think that it's okay. We already have
> jaw-droppingly expensive VM instance to keep up with the build volume.
> And the list is very busy. So we can't afford "post to run the CI"
> development model.

OK, I just afraid the developer doesn't check patchwork status.

> > +files=$(git show --name-status --oneline | grep -P '^A\ttools/testing/selftests/net/' | grep '\.sh$' | sed 's@A\ttools/testing/selftests/net/@@')
> > +for file in $files; do
> > +	if echo $file | grep forwarding; then
> > +		file=$(echo $file | sed 's/forwarding\///')
> > +		if ! grep -P "[\t| ]$file" tools/testing/selftests/net/forwarding/Makefile;then
> > +			echo "new test $file not in selftests/net/forwarding/Makefile" >&$DESC_FD
> > +			rc=1
> > +		fi
> > +	else
> > +		if ! grep -P "[\t| ]$file" tools/testing/selftests/net/Makefile;then
> > +			echo "new test $file not in selftests/net/Makefile" >&$DESC_FD
> > +			rc=1
> > +		fi
> 
> Does it matter which exact selftest makefile the changes are?

I only checked the tools/testing/selftests/net/Makefile and
tools/testing/selftests/net/forwarding/Makefile at present.
Maybe mptcp should also added?

> Maybe as a first stab we should just check if there are changes 
> to anything in tools/testing/selftests/.*/Makefile?

In my checking only shell scripts are checked, as most net net/forwarding tests
using shell script for testing. But other sub-component may use c binary or
python for testing. So I think there is no need to check all
tools/testing/selftests/.*/Makefile. WDYT?

Thanks
Hangbin
