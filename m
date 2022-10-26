Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78FFE60DA77
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 07:09:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231628AbiJZFJB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 01:09:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbiJZFJA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 01:09:00 -0400
Received: from mail-oa1-x2f.google.com (mail-oa1-x2f.google.com [IPv6:2001:4860:4864:20::2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 195F3BA27E
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 22:08:59 -0700 (PDT)
Received: by mail-oa1-x2f.google.com with SMTP id 586e51a60fabf-12c8312131fso18697485fac.4
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 22:08:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=v306Pm5d1giFrK0u9y2JLpdRUQEpZpzRvKWY7khI884=;
        b=BKa6WNbNR9lg2iRBhC25+LdUc1ofwMJJ0acX/OrlVeHXhc2QT+LgbMyFP8axwVTWod
         cYaYBrZw5lj1WXOsrmwYeZkpee1FX36CB6adNjZKlAgH8vMmKsLyCFCjM1KdDIzDos08
         bwrTcazfSLb1EeSMlZuFwsDPLXH+GDLavTh90B+402xwtP2nA8pAthwbF317cHV3eK6X
         XZRWg7mzsy9ilyik4dbdg9TXHJLYIsAp17FFlwEosQoaRdZeNtOyYfH7g+ug2BBwD25H
         v4a8xY/qjsZEOWru7FQPSR7gWhFcKGwlcj+tpB7spT1izq65ACCyCuCvhsddhXeiNTog
         9+fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=v306Pm5d1giFrK0u9y2JLpdRUQEpZpzRvKWY7khI884=;
        b=fCKLYKeZCNiXUeySbV7hHA+e1QvPjly6LelN4VjOPade4XKWUDzzoRHo27kyNT+BrV
         kBU62r41mzcLUoIxUYGfwyx4OljmOqwGJC8wGXFShIrR405Lc6f0ymJDWqbuhzIo1Wfx
         5HO1ftIp7ALLFp4/J/1aHW+oFai2QESNuJ3CA2dWRs9qYLj7fta9wkEA+fWgvE/3Nq6d
         ijfPsKP9OvhlznubFzSbSgwAryeWuQ3QXwRMqwEpmuuYi8NOS8avsHMQlpxo/Y+jAnaX
         AQZTZk7nuXcFM7Jqc96yYRSszoXDcL68bmac+i6A9oYItT/KS0j7nFnUV41EPI3wEcB2
         xG+Q==
X-Gm-Message-State: ACrzQf0MY1DFdPvadg5P0NcUjvK+r8K8eUY2vkxq6jU9doZGgRgk3DYe
        HqeZ+hQlCCkJaL3drxDb3kJhx0PCeM6oYtNDe0PQgw==
X-Google-Smtp-Source: AMsMyM6H0JPCdNoQWhSXgUNWsFPKDKWVJduuVHBo8yFrEUCxEvxyGTbVJafsr+FRUSV6hOyCOxK6oZinjxLHtnWTmJc=
X-Received: by 2002:a05:6870:61ca:b0:13b:ac21:a23 with SMTP id
 b10-20020a05687061ca00b0013bac210a23mr1108937oah.106.1666760938329; Tue, 25
 Oct 2022 22:08:58 -0700 (PDT)
MIME-Version: 1.0
References: <20221024111603.2185410-1-victor@mojatatu.com>
In-Reply-To: <20221024111603.2185410-1-victor@mojatatu.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Wed, 26 Oct 2022 01:08:47 -0400
Message-ID: <CAM0EoMnyjyLYokQ7kC6Zbicq3CTwiBE0oueQ5bDJRFhkPN8W3g@mail.gmail.com>
Subject: Re: [PATCH] selftests: tc-testing: Add matchJSON to tdc
To:     Victor Nogueira <victor@mojatatu.com>
Cc:     davem@davemloft.net, jiri@resnulli.us, kuba@kernel.org,
        netdev@vger.kernel.org, xiyou.wangcong@gmail.com,
        edumazet@google.com, pabeni@redhat.com,
        Jeremy Carter <jeremy@mojatatu.com>,
        Jeremy Carter <jeremy@jeremycarter.ca>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 24, 2022 at 7:31 AM Victor Nogueira <victor@mojatatu.com> wrote:
>
> This allows the use of a matchJSON field in tests to match
> against JSON output from the command under test, if that
> command outputs JSON.
>
> You specify what you want to match against as a JSON array
> or object in the test's matchJSON field. You can leave out
> any fields you don't want to match against that are present
> in the output and they will be skipped.
>
> An example matchJSON value would look like this:
>
> "matchJSON": [
>   {
>     "Value": {
>       "neighIP": {
>         "family": 4,
>         "addr": "AQIDBA==",
>         "width": 32
>       },
>       "nsflags": 142,
>       "ncflags": 0,
>       "LLADDR": "ESIzRFVm"
>     }
>   }
> ]
>
> The real output from the command under test might have some
> extra fields that we don't care about for matching, and
> since we didn't include them in our matchJSON value, those
> fields will not be attempted to be matched. If everything
> we included above has the same values as the real command
> output, the test will pass.
>
> The matchJSON field's type must be the same as the command
> output's type, otherwise the test will fail. So if the
> command outputs an array, then the value of matchJSON must
> also be an array.
>
> If matchJSON is an array, it must not contain more elements
> than the command output's array, otherwise the test will
> fail.
>
> Signed-off-by: Jeremy Carter <jeremy@mojatatu.com>
> Signed-off-by: Victor Nogueira <victor@mojatatu.com>

Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>

cheers,
jamal

> ---
>  tools/testing/selftests/tc-testing/tdc.py | 125 ++++++++++++++++++++--
>  1 file changed, 118 insertions(+), 7 deletions(-)
>
> diff --git a/tools/testing/selftests/tc-testing/tdc.py b/tools/testing/selftests/tc-testing/tdc.py
> index ee22e3447..7bd94f8e4 100755
> --- a/tools/testing/selftests/tc-testing/tdc.py
> +++ b/tools/testing/selftests/tc-testing/tdc.py
> @@ -246,6 +246,110 @@ def prepare_env(args, pm, stage, prefix, cmdlist, output = None):
>                  stage, output,
>                  '"{}" did not complete successfully'.format(prefix))
>
> +def verify_by_json(procout, res, tidx, args, pm):
> +    try:
> +        outputJSON = json.loads(procout)
> +    except json.JSONDecodeError:
> +        res.set_result(ResultState.fail)
> +        res.set_failmsg('Cannot decode verify command\'s output. Is it JSON?')
> +        return res
> +
> +    matchJSON = json.loads(json.dumps(tidx['matchJSON']))
> +
> +    if type(outputJSON) != type(matchJSON):
> +        failmsg = 'Original output and matchJSON value are not the same type: output: {} != matchJSON: {} '
> +        failmsg = failmsg.format(type(outputJSON).__name__, type(matchJSON).__name__)
> +        res.set_result(ResultState.fail)
> +        res.set_failmsg(failmsg)
> +        return res
> +
> +    if len(matchJSON) > len(outputJSON):
> +        failmsg = "Your matchJSON value is an array, and it contains more elements than the command under test\'s output:\ncommand output (length: {}):\n{}\nmatchJSON value (length: {}):\n{}"
> +        failmsg = failmsg.format(len(outputJSON), outputJSON, len(matchJSON), matchJSON)
> +        res.set_result(ResultState.fail)
> +        res.set_failmsg(failmsg)
> +        return res
> +    res = find_in_json(res, outputJSON, matchJSON, 0)
> +
> +    return res
> +
> +def find_in_json(res, outputJSONVal, matchJSONVal, matchJSONKey=None):
> +    if res.get_result() == ResultState.fail:
> +        return res
> +
> +    if type(matchJSONVal) == list:
> +        res = find_in_json_list(res, outputJSONVal, matchJSONVal, matchJSONKey)
> +
> +    elif type(matchJSONVal) == dict:
> +        res = find_in_json_dict(res, outputJSONVal, matchJSONVal)
> +    else:
> +        res = find_in_json_other(res, outputJSONVal, matchJSONVal, matchJSONKey)
> +
> +    if res.get_result() != ResultState.fail:
> +        res.set_result(ResultState.success)
> +        return res
> +
> +    return res
> +
> +def find_in_json_list(res, outputJSONVal, matchJSONVal, matchJSONKey=None):
> +    if (type(matchJSONVal) != type(outputJSONVal)):
> +        failmsg = 'Original output and matchJSON value are not the same type: output: {} != matchJSON: {}'
> +        failmsg = failmsg.format(outputJSONVal, matchJSONVal)
> +        res.set_result(ResultState.fail)
> +        res.set_failmsg(failmsg)
> +        return res
> +
> +    if len(matchJSONVal) > len(outputJSONVal):
> +        failmsg = "Your matchJSON value is an array, and it contains more elements than the command under test\'s output:\ncommand output (length: {}):\n{}\nmatchJSON value (length: {}):\n{}"
> +        failmsg = failmsg.format(len(outputJSONVal), outputJSONVal, len(matchJSONVal), matchJSONVal)
> +        res.set_result(ResultState.fail)
> +        res.set_failmsg(failmsg)
> +        return res
> +
> +    for matchJSONIdx, matchJSONVal in enumerate(matchJSONVal):
> +        res = find_in_json(res, outputJSONVal[matchJSONIdx], matchJSONVal,
> +                           matchJSONKey)
> +    return res
> +
> +def find_in_json_dict(res, outputJSONVal, matchJSONVal):
> +    for matchJSONKey, matchJSONVal in matchJSONVal.items():
> +        if type(outputJSONVal) == dict:
> +            if matchJSONKey not in outputJSONVal:
> +                failmsg = 'Key not found in json output: {}: {}\nMatching against output: {}'
> +                failmsg = failmsg.format(matchJSONKey, matchJSONVal, outputJSONVal)
> +                res.set_result(ResultState.fail)
> +                res.set_failmsg(failmsg)
> +                return res
> +
> +        else:
> +            failmsg = 'Original output and matchJSON value are not the same type: output: {} != matchJSON: {}'
> +            failmsg = failmsg.format(type(outputJSON).__name__, type(matchJSON).__name__)
> +            res.set_result(ResultState.fail)
> +            res.set_failmsg(failmsg)
> +            return rest
> +
> +        if type(outputJSONVal) == dict and (type(outputJSONVal[matchJSONKey]) == dict or
> +                type(outputJSONVal[matchJSONKey]) == list):
> +            if len(matchJSONVal) > 0:
> +                res = find_in_json(res, outputJSONVal[matchJSONKey], matchJSONVal, matchJSONKey)
> +            # handling corner case where matchJSONVal == [] or matchJSONVal == {}
> +            else:
> +                res = find_in_json_other(res, outputJSONVal, matchJSONVal, matchJSONKey)
> +        else:
> +            res = find_in_json(res, outputJSONVal, matchJSONVal, matchJSONKey)
> +    return res
> +
> +def find_in_json_other(res, outputJSONVal, matchJSONVal, matchJSONKey=None):
> +    if matchJSONKey in outputJSONVal:
> +        if matchJSONVal != outputJSONVal[matchJSONKey]:
> +            failmsg = 'Value doesn\'t match: {}: {} != {}\nMatching against output: {}'
> +            failmsg = failmsg.format(matchJSONKey, matchJSONVal, outputJSONVal[matchJSONKey], outputJSONVal)
> +            res.set_result(ResultState.fail)
> +            res.set_failmsg(failmsg)
> +            return res
> +
> +    return res
> +
>  def run_one_test(pm, args, index, tidx):
>      global NAMES
>      result = True
> @@ -292,16 +396,22 @@ def run_one_test(pm, args, index, tidx):
>      else:
>          if args.verbose > 0:
>              print('-----> verify stage')
> -        match_pattern = re.compile(
> -            str(tidx["matchPattern"]), re.DOTALL | re.MULTILINE)
>          (p, procout) = exec_cmd(args, pm, 'verify', tidx["verifyCmd"])
>          if procout:
> -            match_index = re.findall(match_pattern, procout)
> -            if len(match_index) != int(tidx["matchCount"]):
> -                res.set_result(ResultState.fail)
> -                res.set_failmsg('Could not match regex pattern. Verify command output:\n{}'.format(procout))
> +            if 'matchJSON' in tidx:
> +                verify_by_json(procout, res, tidx, args, pm)
> +            elif 'matchPattern' in tidx:
> +                match_pattern = re.compile(
> +                    str(tidx["matchPattern"]), re.DOTALL | re.MULTILINE)
> +                match_index = re.findall(match_pattern, procout)
> +                if len(match_index) != int(tidx["matchCount"]):
> +                    res.set_result(ResultState.fail)
> +                    res.set_failmsg('Could not match regex pattern. Verify command output:\n{}'.format(procout))
> +                else:
> +                    res.set_result(ResultState.success)
>              else:
> -                res.set_result(ResultState.success)
> +                res.set_result(ResultState.fail)
> +                res.set_failmsg('Must specify a match option: matchJSON or matchPattern\n{}'.format(procout))
>          elif int(tidx["matchCount"]) != 0:
>              res.set_result(ResultState.fail)
>              res.set_failmsg('No output generated by verify command.')
> @@ -365,6 +475,7 @@ def test_runner(pm, args, filtered_tests):
>              res.set_result(ResultState.skip)
>              res.set_errormsg(errmsg)
>              tsr.add_resultdata(res)
> +            index += 1
>              continue
>          try:
>              badtest = tidx  # in case it goes bad
> --
> 2.25.1
>
