Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AD4242403C
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 16:37:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239042AbhJFOjp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 10:39:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238959AbhJFOjo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 10:39:44 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FBFFC061749;
        Wed,  6 Oct 2021 07:37:52 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id p80so3037665iod.10;
        Wed, 06 Oct 2021 07:37:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kn9Gf4mGo3E2D2C2kiGo7cnTH0713o7DJgJh8Dkrqww=;
        b=SxodPL/G+rIXc1V8SIMG9ypGXxmwSFxhNfAxtRjP8lGV+JdINFe/9P8+Zrx4887ihr
         f1ozlefK6LwwFWR2491QY7wTDzXxuGzoy0uKHbL410El8TPQLgA3NPVskXLTJKflTfKT
         QvC3b7tUry6wiGKoEzmyr0veCgKvNPmMyx0xR2t3xuQ9QDaskTyno9IujZIP3FjYOfe4
         0tpxCT8feiCjemXkgXj7nimzxYF8vRo/z7dPzGUmkUAuiP/C+gtjwwjcI1xlvLbpR1HI
         6O47CSDHDBFyYpabB2leEBJWdFFHb7+5taxTSA5x19KkhjBC1zOVu2P2zPcH9547N6Wa
         EVgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kn9Gf4mGo3E2D2C2kiGo7cnTH0713o7DJgJh8Dkrqww=;
        b=O7DeJzTf6daYR4Y3ghzoK6Xt0rdGJZYLgWys/H02/GpHxQTxAGkw4KnjR81J9VJVC5
         T0URNgGrP3iOwx7pZOi62vxTP5DOTxu03xkE0Ni0fpPGSUZ6Ekwe3TcjB/XxG4KLJJjv
         To9hCO2pYJUD3vsyDIhpH9FULStwmkka0M5s/pbPy49lwxb0VF8vHb5H7/bzLCajrGCo
         yzN3LXlH7s9chE3/Ih+XrmcnEzEGhL0y7GvLk5oKArOrx5//lf/VSZ/8nbJVaqq6xnpK
         MWX1mlSx/P8EBI3viv2Lk++aVSa7MbVQO1lVbR+qvVkpllqt02kTQqV7ShKKBb1GCWz8
         M2pg==
X-Gm-Message-State: AOAM531VJwlanZBRajheLRJnAQUc/YIsiYEcPihoIKFr1cZ3txWRM1Kp
        UBcVkpGzKjCeJWg5GIZnyCZKSMDzXwdwyQ==
X-Google-Smtp-Source: ABdhPJwwPWGXHWPiqhpwJshKOT7jv1x94UtEbme8eqL0jBy51wRbSl3GvPEUFHkpg1OzXwjRWNwKsQ==
X-Received: by 2002:a05:6602:214f:: with SMTP id y15mr6763425ioy.127.1633531071634;
        Wed, 06 Oct 2021 07:37:51 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id v63sm12247947ioe.17.2021.10.06.07.37.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Oct 2021 07:37:51 -0700 (PDT)
Subject: Re: [PATCH 03/11] selftests: net/fcnal: Non-zero exit on failures
To:     Leonard Crestez <cdleonard@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>, David Ahern <dsahern@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Ido Schimmel <idosch@nvidia.com>,
        Seth David Schoen <schoen@loyalty.org>,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1633520807.git.cdleonard@gmail.com>
 <f8479130ce46322d75b0556273c16b45522b5ff4.1633520807.git.cdleonard@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <18b07120-6596-6d39-f707-95e9379a78da@gmail.com>
Date:   Wed, 6 Oct 2021 08:37:50 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <f8479130ce46322d75b0556273c16b45522b5ff4.1633520807.git.cdleonard@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/6/21 5:47 AM, Leonard Crestez wrote:
> Test scripts must report 'pass' or 'fail' via exit status, not just
> logging.
> 
> Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
> ---
>  tools/testing/selftests/net/fcnal-test.sh | 1 +
>  1 file changed, 1 insertion(+)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


