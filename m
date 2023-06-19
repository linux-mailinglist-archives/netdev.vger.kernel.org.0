Return-Path: <netdev+bounces-11985-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A9F3373596B
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 16:24:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C5E2028113D
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 14:24:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2E9F125BB;
	Mon, 19 Jun 2023 14:24:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D74EA10955
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 14:24:42 +0000 (UTC)
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0600FE;
	Mon, 19 Jun 2023 07:24:38 -0700 (PDT)
Received: from lhrpeml500004.china.huawei.com (unknown [172.18.147.226])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4QlBm85Nc6z6D93N;
	Mon, 19 Jun 2023 22:22:00 +0800 (CST)
Received: from [10.123.123.126] (10.123.123.126) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 19 Jun 2023 15:24:35 +0100
Message-ID: <c0713bf1-a65e-c4cd-08b9-c60bd79fc86f@huawei.com>
Date: Mon, 19 Jun 2023 17:24:17 +0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v11 11/12] samples/landlock: Add network demo
Content-Language: ru
To: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>,
	=?UTF-8?Q?G=c3=bcnther_Noack?= <gnoack@google.com>
CC: <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>
References: <20230515161339.631577-1-konstantin.meskhidze@huawei.com>
 <20230515161339.631577-12-konstantin.meskhidze@huawei.com>
 <ZH9OFyWZ1njI7VG9@google.com>
 <d9f07165-f589-13d4-6484-1272704f1de0@huawei.com>
 <8c09fc5a-e3a5-4792-65a8-b84c6044128a@digikod.net>
From: "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
In-Reply-To: <8c09fc5a-e3a5-4792-65a8-b84c6044128a@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.123.123.126]
X-ClientProxiedBy: lhrpeml500002.china.huawei.com (7.191.160.78) To
 lhrpeml500004.china.huawei.com (7.191.163.9)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



6/13/2023 11:38 PM, Mickaël Salaün пишет:
> 
> On 13/06/2023 12:54, Konstantin Meskhidze (A) wrote:
>> 
>> 
>> 6/6/2023 6:17 PM, Günther Noack пишет:
>>> Hi Konstantin!
>>>
>>> Apologies if some of this was discussed before, in this case,
>>> Mickaël's review overrules my opinions from the sidelines ;)
>>>
>>> On Tue, May 16, 2023 at 12:13:38AM +0800, Konstantin Meskhidze wrote:
>>>> This commit adds network demo. It's possible to allow a sandboxer to
>>>> bind/connect to a list of particular ports restricting network
>>>> actions to the rest of ports.
>>>>
>>>> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
>>>
>>>
>>>> diff --git a/samples/landlock/sandboxer.c b/samples/landlock/sandboxer.c
>>>> index e2056c8b902c..b0250edb6ccb 100644
>>>> --- a/samples/landlock/sandboxer.c
>>>> +++ b/samples/landlock/sandboxer.c
>>>
>>> ...
>>>
>>>> +static int populate_ruleset_net(const char *const env_var, const int ruleset_fd,
>>>> +				const __u64 allowed_access)
>>>> +{
>>>> +	int num_ports, i, ret = 1;
>>>
>>> I thought the convention was normally to set ret = 0 initially and to
>>> override it in case of error, rather than the other way around?
> 
> Which convention? In this case, by default the return code is an error.
> 
> 
>>>
>>     Well, I just followed Mickaёl's way of logic here. >
>> 
>>>> +	char *env_port_name;
>>>> +	struct landlock_net_service_attr net_service = {
>>>> +		.allowed_access = allowed_access,
>>>> +		.port = 0,
>>>> +	};
>>>> +
>>>> +	env_port_name = getenv(env_var);
>>>> +	if (!env_port_name)
>>>> +		return 0;
>>>> +	env_port_name = strdup(env_port_name);
>>>> +	unsetenv(env_var);
>>>> +	num_ports = parse_port_num(env_port_name);
>>>> +
>>>> +	if (num_ports == 1 && (strtok(env_port_name, ENV_PATH_TOKEN) == NULL)) {
>>>> +		ret = 0;
>>>> +		goto out_free_name;
>>>> +	}
>>>
>>> I don't understand why parse_port_num and strtok are necessary in this
>>> program. The man-page for strsep(3) describes it as a replacement to
>>> strtok(3) (in the HISTORY section), and it has a very short example
>>> for how it is used.
>>>
>>> Wouldn't it work like this as well?
>>>
>>> while ((strport = strsep(&env_port_name, ":"))) {
>>>     net_service.port = atoi(strport);
>>>     /* etc */
>>> }
>> 
>>     Thanks for a tip. I think it's a better solution here. Now this
>> commit is in Mickaёl's -next branch. I could send a one-commit patch later.
>> Mickaёl, what do you think?
> 
> I removed this series from -next because there is some issues (see the
> bot's emails), but anyway, this doesn't mean these patches don't need to
> be changed, they do. The goal of -next is to test more widely a patch
> series and get more feedbacks, especially from bots. When this series
> will be fully ready (and fuzzed with syzkaller), I'll push it to Linus
> Torvalds.
> 
> I'll review the remaining tests and sample code this week, but you can
> still take into account the documentation review.

  Hi, Mickaёl.

  I have a few quetions?
   - Are you going to fix warnings for bots, meanwhile I run syzcaller?
   - I will fix documentation and sandbox demo and sent patch v12?

> 
> 
>> 
>>>
>>>> +
>>>> +	for (i = 0; i < num_ports; i++) {
>>>> +		net_service.port = atoi(strsep(&env_port_name, ENV_PATH_TOKEN));
>>>
>>> Naming of ENV_PATH_TOKEN:
>>> This usage is not related to paths, maybe rename the variable?
>>> It's also technically not the token, but the delimiter.
>>>
>>    What do you think of ENV_PORT_TOKEN or ENV_PORT_DELIMITER???
> 
> You can rename ENV_PATH_TOKEN to ENV_DELIMITER for the FS and network parts.
> 
    Ok. Got it.
> 
>> 
>>>> +		if (landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_SERVICE,
>>>> +				      &net_service, 0)) {
>>>> +			fprintf(stderr,
>>>> +				"Failed to update the ruleset with port \"%lld\": %s\n",
>>>> +				net_service.port, strerror(errno));
>>>> +			goto out_free_name;
>>>> +		}
>>>> +	}
>>>> +	ret = 0;
>>>> +
>>>> +out_free_name:
>>>> +	free(env_port_name);
>>>> +	return ret;
>>>> +}
>>>
>>>
>>>>   		fprintf(stderr,
>>>>   			"Launch a command in a restricted environment.\n\n");
>>>> -		fprintf(stderr, "Environment variables containing paths, "
>>>> -				"each separated by a colon:\n");
>>>> +		fprintf(stderr,
>>>> +			"Environment variables containing paths and ports "
>>>> +			"each separated by a colon:\n");
>>>>   		fprintf(stderr,
>>>>   			"* %s: list of paths allowed to be used in a read-only way.\n",
>>>>   			ENV_FS_RO_NAME);
>>>>   		fprintf(stderr,
>>>> -			"* %s: list of paths allowed to be used in a read-write way.\n",
>>>> +			"* %s: list of paths allowed to be used in a read-write way.\n\n",
>>>>   			ENV_FS_RW_NAME);
>>>> +		fprintf(stderr,
>>>> +			"Environment variables containing ports are optional "
>>>> +			"and could be skipped.\n");
>>>
>>> As it is, I believe the program does something different when I'm
>>> setting these to the empty string (ENV_TCP_BIND_NAME=""), compared to
>>> when I'm unsetting them?
>>>
>>> I think the case where we want to forbid all handle-able networking is
>>> a legit and very common use case - it could be clearer in the
>>> documentation how this is done with the tool. (And maybe the interface
>>> could be something more explicit than setting the environment variable
>>> to empty?)
> 
> I'd like to keep it simple, and it should be seen as an example code,
> not a full-feature sandboxer, but still a consistent and useful one.
> What would you suggest?
> 
> This sandboxer tool relies on environment variables for its
> configuration. This is definitely not a good fit for all use cases, but
> I think it is simple and flexible enough. One use case might be to
> export a set of environment variables and simply call this tool. I'd
> prefer to not deal with argument parsing, but maybe that was too
> simplistic? We might want to revisit this approach but probably not with
> this series.
> 
> 
>>>
>>>
>>>> +	/* Removes bind access attribute if not supported by a user. */
>>>> +	env_port_name = getenv(ENV_TCP_BIND_NAME);
>>>> +	if (!env_port_name) {
>>>> +		ruleset_attr.handled_access_net &=
>>>> +			~LANDLOCK_ACCESS_NET_BIND_TCP;
>>>> +	}
>>>> +	/* Removes connect access attribute if not supported by a user. */
>>>> +	env_port_name = getenv(ENV_TCP_CONNECT_NAME);
>>>> +	if (!env_port_name) {
>>>> +		ruleset_attr.handled_access_net &=
>>>> +			~LANDLOCK_ACCESS_NET_CONNECT_TCP;
>>>> +	}
>>>
>>> This is the code where the program does not restrict network usage,
>>> if the corresponding environment variable is not set.
>> 
>>     Yep. Right.
>>>
>>> It's slightly inconsistent with what this tool does for filesystem
>>> paths. - If you don't specify any file paths, it will still restrict
>>> file operations there, independent of whether that env variable was
>>> set or not.  (Apologies if it was discussed before.)
>> 
>>    Mickaёl wanted to make network ports optional here.
>>    Please check:
>>   
>> https://lore.kernel.org/linux-security-module/179ac2ee-37ff-92da-c381-c2c716725045@digikod.net/
> 
> Right, the rationale is for compatibility with the previous version of
> this tool. We should not break compatibility when possible. A comment
> should explain the rationale though.
> 
>> 
>> https://lore.kernel.org/linux-security-module/fe3bc928-14f8-5e2b-359e-9a87d6cf5b01@digikod.net/
>>>
>>> —Günther
>>>
> .

